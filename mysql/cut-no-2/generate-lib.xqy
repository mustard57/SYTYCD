module namespace generate-lib = "http://marklogic.com/SYTYCD/generate-lib";

import module namespace bespoke = "http://marklogic.com/SYTYCD/bespoke-generation" at "/bespoke.xqy";

declare variable $upper-case-letters := "ABDDEFGHIJKLMNOPQRSTUVWXYZ";
declare variable $lower-case-letters := fn:lower-case($upper-case-letters);

declare variable $DEFAULT-INT-TYPE := "int(11)";
declare variable $STRING-TYPE := "varchar(255)";
declare variable $DATE-TYPE := "datetime";
declare variable $LF := fn:codepoints-to-string(10);
declare variable $TAB := fn:codepoints-to-string(9);

declare variable $FROM-FILE-TEMPLATE-TYPE := "from-file";
declare variable $RANDOM-TEMPLATE-TYPE := "random";
declare variable $RANGE-TEMPLATE-TYPE := "range";
declare variable $COUNTER-TEMPLATE-TYPE := "counter";
declare variable $WEIGHTED-RANDOM-TEMPLATE-TYPE := "weighted";
declare variable $FUNCTION-TEMPLATE-TYPE := "function";
declare variable $FOREIGN-KEY-TEMPLATE-TYPE := "fkey";
declare variable $ID-FROM-MAP-TEMPLATE-TYPE := "id-from-map";
declare variable $UNIQUE-ID-FROM-MAP-TEMPLATE-TYPE := "unique-id-from-map";
declare variable $TABLE-LOOKUP-TEMPLATE-TYPE := "table-lookup";


declare variable $DEFAULT-ROW-COUNT := 0;
declare variable $RANDOM-PREFIX := "random:";
declare variable $RANGE-PREFIX := "range:";
declare variable $COUNTER-PREFIX := "counter:";
declare variable $WEIGHTED-RANDOM-PREFIX := "weighted:";
declare variable $FUNCTION-PREFIX := "function:";
declare variable $FOREIGN-KEY-PREFIX := "fkey:";
declare variable $ID-FROM-MAP-PREFIX := "id-from-map:";
declare variable $UNIQUE-ID-FROM-MAP-PREFIX := "unique-id-from-map:";
declare variable $TABLE-LOOKUP-PREFIX := "table-lookup:";

declare variable $TABLE-DATA-MAPS := map:map();

declare function generate-schema($specification as element(root),$schema-file-name as xs:string){
    let $null := xdmp:eval('import module namespace bespoke = "http://marklogic.com/SYTYCD/bespoke-generation" at "/bespoke.xqy"; 
    declare variable $schema as element(root) external;
    bespoke:create-sort-codes($schema)',
    
        (xs:QName("schema"),$specification))
    let $text := text{
        generate-lib:get-header($specification),
        for $table in $specification/table
        return
        generate-lib:create-table-statement($table),
        for $table in $specification/table
        return
        generate-lib:insert-statements($table),
        for $table in $specification/data
        return
        generate-lib:insert-statements($table)        
    }
    return
    xdmp:save($schema-file-name,$text),
    $specification//table-name/text()
};

declare function create-table-statement($table as element(table)) as xs:string{
    map:put($TABLE-DATA-MAPS,$table/table-name/text(),map:map()),
    "CREATE TABLE `"||$table/table-name/text()||"` ("||$LF||
    (
        fn:string-join((
            let $pkey := element pkey{
                if($table/pkey = "auto") then
                    $table/table-name/text()||"_ID"
                else
                    $table/pkey/text()
                }
            let $type-desc := 
            if($table/enum or fn:ends-with($table/table-name,"-TYPE")) then
                element field{$table/table-name/text()}
            else()
            return
            (                
                for $field in ($pkey,$type-desc,$table/fields/(field|fkey))
                let $type := 
                    typeswitch($field)
                        case element(field) return 
                            if($field/@type) then $field/@type else if(fn:matches($field,"DATE$")) then $DATE-TYPE else $STRING-TYPE
                        case element(fkey) return $DEFAULT-INT-TYPE
                        case element(pkey) return $DEFAULT-INT-TYPE
                        default return $STRING-TYPE                
                let $field-name := 
                    typeswitch($field)
                        case element(field) return $field/text()
                        case element(fkey) return $field/text()||"_ID"
                        case element(pkey) return $field/text()
                        default return ()
                        
                return
                $TAB||"`"||$field-name||"` "||$type||" NOT NULL,"||$LF
                
                ,
                
                $TAB||"PRIMARY KEY (`"||$pkey||"`)"||$LF,
                for $fkey in $table/fields/fkey
                return
                $TAB||",KEY `"||$fkey||"_ID` (`"||$fkey||"_ID"||"`)"||$LF
                ,
                for $fkey in $table/fields/fkey
                return
                $TAB||",CONSTRAINT `"||$table/table-name/text()||"_"||$fkey||"_ID` FOREIGN KEY (`"||$fkey||"_ID"||"`) REFERENCES `"||$fkey||"` (`"||$fkey||"_ID`)"||$LF
              
            )
            
        ),"")
    )
    ||") ENGINE = InnoDB;"||$LF
};

declare function get-header($table-config as element(root)) as xs:string*{
    "drop schema if exists "||$table-config/schema-name||";",
    $generate-lib:LF,
    "create schema "||$table-config/schema-name||";",
    $generate-lib:LF,
    "use "||$table-config/schema-name/text()||";",
    $generate-lib:LF,
    "SET NAMES utf8;",
    $generate-lib:LF,
    "SET FOREIGN_KEY_CHECKS = 0;",
    $generate-lib:LF
};

declare function insert-statements($table) as xs:string*{
    let $data-files := get-data-files($table)
    let $row-count := if($table/@rows) then xs:int($table/@rows) else $DEFAULT-ROW-COUNT
    let $table-map := map:get($TABLE-DATA-MAPS,$table/table-name/text())
    let $table-data := copy-table-data-maps() 
    return     
    if($table/enum) then
        for $val at $pos in $table/enum/val
        return 
        "INSERT INTO `"||$table/table-name/text()||"` VALUES("||$pos||",'"||$val/text()||"');"||$LF
    else
        for $count in (1 to $row-count)
        let $map := get-random-rows($data-files)
        let $row-value-map := map:map()
        let $pkey := 
            if($table/pkey/@content) then
                parse-field-template($table/pkey/@content,"",$map,$count,$row-value-map,$table-data)
            else
            xs:string($count)
        
        return
        (
            "INSERT INTO `"||$table/table-name/text()||"` VALUES("||
            fn:string-join((
                $pkey,
                for $template in $table/fields/(field/@content|fkey/@content)
                let $field-name := $template/../text()
                let $quote := 
                    typeswitch($template/..)
                        case(element(field)) return "'"
                        default return ""
                let $value := parse-field-template($template,$field-name,$map,$count,$row-value-map,$table-data)
                let $null := map:put($row-value-map,$field-name,$value) 
                return
                $quote||$value||$quote 
                ),",")||");"||$LF,
                map:put($table-map,$pkey,$row-value-map)        
        )
};    

(: Process a template :)
declare function parse-field-template($template as xs:string,$field-name as xs:string,$random-row-map as map:map,$count as xs:int,$row-value-map as map:map,$table-data-maps as map:map){
    let $components := fn:tokenize($template,"\|")
    return
    fn:string-join(
        for $component in $components
        let $template-type := get-template-type($component)
        return
        if($template-type = $FROM-FILE-TEMPLATE-TYPE) then
            let $file := get-data-file($component)
            let $column-position := get-column-position($component)
            return
            fn:replace(map:get($random-row-map,$file)[$column-position],"'","")
        else if($template-type = $RANDOM-TEMPLATE-TYPE) then
            let $pattern := get-random-pattern($component)
            return
            random-from-pattern($pattern)
        else if($template-type = $RANGE-TEMPLATE-TYPE) then
            random-from-range(get-range($component))            
        else if($template-type = $COUNTER-TEMPLATE-TYPE) then
            xs:string(get-counter-start($component) + $count)
        else if($template-type = $WEIGHTED-RANDOM-TEMPLATE-TYPE) then        
            xs:string(random-from-weighted-random(fn:replace($component,$WEIGHTED-RANDOM-PREFIX,"")))
        else if($template-type = $FUNCTION-TEMPLATE-TYPE) then
            let $values := fn:replace($component,$FUNCTION-PREFIX,"")
            let $function-name := fn:tokenize($values,",")[1]
            let $value := fn:tokenize($values,",")[2]
            let $row-value := map:get($row-value-map,$value)
            let $row-value := if($row-value) then $row-value else ""
            return
            xdmp:apply(xdmp:function(xs:QName("bespoke:"||$function-name)),$row-value)
        else if($template-type = $ID-FROM-MAP-TEMPLATE-TYPE) then
            let $table-map := map:get($table-data-maps,$field-name)
            let $random := xdmp:random(fn:count(map:keys($table-map)) - 1) + 1
            return
            map:keys($table-map)[$random] 
        else if($template-type = $UNIQUE-ID-FROM-MAP-TEMPLATE-TYPE) then
            let $table-map := map:get($table-data-maps,$field-name)
            let $random := xdmp:random(fn:count(map:keys($table-map)) - 1) + 1
            let $value := map:keys($table-map)[$random]
            let $null := map:delete($table-map,$value) 
            return
            $value             
        else if($template-type = $TABLE-LOOKUP-TEMPLATE-TYPE) then
            let $values := fn:tokenize(fn:replace($component,$TABLE-LOOKUP-PREFIX,""),",")
            let $from-table := $values[1]
            let $field := $values[2]
            let $field-value := map:get($row-value-map,$from-table)
            let $from-table-map := map:get($TABLE-DATA-MAPS,$from-table)
            return
            map:get(map:get(map:get($TABLE-DATA-MAPS,$from-table),$field-value),$field)
        else    
            $component
    ,"")
};

(: Get the template type :)
declare private function get-template-type($string) as xs:string{
    if(fn:matches($string,"^/.*\[\d+\]$")) then
        $FROM-FILE-TEMPLATE-TYPE
    else if(fn:starts-with($string,$RANDOM-PREFIX)) then    
        $RANDOM-TEMPLATE-TYPE
    else if(fn:starts-with($string,$RANGE-PREFIX)) then
        $RANGE-TEMPLATE-TYPE
    else if(fn:starts-with($string,$COUNTER-PREFIX)) then
        $COUNTER-TEMPLATE-TYPE
    else if(fn:starts-with($string,$WEIGHTED-RANDOM-PREFIX)) then
        $WEIGHTED-RANDOM-TEMPLATE-TYPE        
    else if(fn:starts-with($string,$FUNCTION-PREFIX)) then
        $FUNCTION-TEMPLATE-TYPE        
    else if(fn:starts-with($string,$ID-FROM-MAP-PREFIX)) then
        $ID-FROM-MAP-TEMPLATE-TYPE                
    else if(fn:starts-with($string,$UNIQUE-ID-FROM-MAP-PREFIX)) then
        $UNIQUE-ID-FROM-MAP-TEMPLATE-TYPE                
    else if(fn:starts-with($string,$TABLE-LOOKUP-PREFIX)) then
        $TABLE-LOOKUP-TEMPLATE-TYPE                        
    else
        ""
};

(: Parse a template for the data files that are being used :)
declare private function get-data-file($string) as xs:string{
    fn:replace($string,"^(/[^\s|\[]*).*$","$1")
};

(: Parse a template for the column position required :)
declare private function get-column-position($string) as xs:int{
    xs:int(fn:replace($string,".*\[([^\]]*).*","$1"))
};

(: Get a random row from a given data file :)
declare private function random-row($data-file) as xs:string{
    let $rows := fn:tokenize(fn:doc($data-file),$LF)  
    let $random := xdmp:random(fn:count($rows)-3) + 2 (: assume trailing line and header. Usual -1, +1 trick plus another one to get beyond header:)
    return
    fn:normalize-space($rows[$random])
};

(: Return a list of the distinct data files used by this table :)
declare private function get-data-files($table-config) as xs:string*{
    fn:distinct-values(
        for $template in $table-config/fields/field/@content
        return
        for $component in fn:tokenize($template,"\|")
        return
        if(get-template-type($component) = $FROM-FILE-TEMPLATE-TYPE) then
            get-data-file($component)
        else()
    )
};

(: Given a list of data files, return a random row for each in a map:)
declare private function get-random-rows($data-files as xs:string*) as map:map{
    let $map := map:map()
    let $null := 
    for $data-file in $data-files
    return
    map:put($map,$data-file,fn:tokenize(random-row($data-file),","))
    return
    $map  
};

declare private function random-digit(){
  xs:string(xdmp:random(9))  
};


declare private function random-letter($input-string){
  let $string-length := fn:string-length($input-string)
  let $random := xdmp:random($string-length - 1) + 1
  return
  fn:substring($input-string,$random,1)
};

declare function random-from-pattern($pattern){
  let $string-length := fn:string-length($pattern)
  return
  fn:string-join(
    for $count in (1 to $string-length)
    let $char := fn:substring($pattern,$count,1)
    return
    if($char = "d") then
      random-digit()
    else if($char = "w") then
      random-letter($lower-case-letters)
    else if($char = "W") then
      random-letter($upper-case-letters)
    else
      $char
    ,"")
  };
  
declare function get-random-pattern($component){
    fn:replace($component,$RANDOM-PREFIX,"")
};

declare function get-counter-start($component) as xs:int{
    xs:int(fn:replace($component,$COUNTER-PREFIX,""))
};
declare function get-range($component) as xs:int*{
    let $range := fn:replace($component,$RANGE-PREFIX,"")
    return
    xs:int(fn:tokenize($range,","))
};

declare function random-from-range($range as xs:int*) as xs:string{
    xs:string(xdmp:random($range[2] - $range[1]) + $range[1])
};

declare function random-from-weighted-random($distribution as xs:string){
    let $items := fn:tokenize($distribution,",")
    let $range := (
     for $item in $items
     let $number := xs:int(fn:tokenize($item,":")[1])
     let $count := xs:int(fn:tokenize($item,":")[2])
     for $i in (1 to $count) return $number
     )
     let $random := xdmp:random(fn:count($range) - 1) + 1
     return
     $range[$random]
};

declare function copy-table-data-maps(){
    let $copy-map := map:map()
    let $null := 
    for $key in map:keys($TABLE-DATA-MAPS)
    let $copy-table-map := map:map()
    let $table-map := map:get($TABLE-DATA-MAPS,$key)
    let $null := map:put($copy-map,$key,$copy-table-map)
    return
    for $field-key in map:keys($table-map)
    return
    map:put($copy-table-map,$field-key,map:get($table-map,$field-key))
    return
    $copy-map    
};