xquery version "1.0-ml";

module namespace m = "http://marklogic.com/roxy/models/rdb2rdf";

import module namespace sem = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";
import module namespace sql  = "http://xqdev.com/sql" at "/app/models/sql.xqy";

declare function m:list-schema($samurl as xs:string) as element(m:list-schema) {
  <m:list-schema>{
    let $res := sql:execute("SELECT DISTINCT ke.TABLE_SCHEMA FROM information_schema.KEY_COLUMN_USAGE ke ORDER BY ke.TABLE_SCHEMA", $samurl, ())
    let $l := xdmp:log($res)
    return
      for $sc in $res/sql:tuple/TABLE_SCHEMA/text()
      return
        <m:schema>{$sc}</m:schema> 
  }</m:list-schema>
};

(:
Fetches database info
parameters supported:-
 - samurl - URL for the MLSAM web services endpoint
 - schema - name of the schema to fetch information for
  
Generates:-

{information: {
    table: [{
      name: "customers", 
      columns: [{column: { name: "custnum", rawtype: "int(11)", xmltype: "xs:integer", nillable: false}}, /* others */],
      metrics: {rowcount: 143}
    }, // others ...
    ],
    relationship: [ {
      table: "t", column: "t", referencedtable: "t", referencedcolumn: "t", constraint: "t", 
    }, /* others */
    ]
}
}

:)
declare function m:get-schema-info($samurl,$schema) as element(m:schema-info) {
  (: global setup :)
  let $types := map:map()
  let $o := map:put($types,"int","xs:integer")
  let $o := map:put($types,"varchar","xs:string")
  return
  <m:schema-info>  
    {
      (: list tables in database :)
      for $tabletuple in sql:execute(fn:concat("SHOW FULL TABLES FROM ",$schema), $samurl, ())/sql:tuple[TABLE_TYPE = "BASE TABLE"] (: restricts to real tables :)
      let $tablename := $tabletuple/TABLE_NAME/text()
      
      (: for each table, fetch field information :)
      return
        <m:table><m:name>{$tablename}</m:name>
        <m:metrics><m:rowcount>{
          sql:execute(fn:concat("SELECT count(*) CNT from ",$schema,".",$tablename), $samurl, ())/sql:tuple/CNT/text()
        }</m:rowcount></m:metrics>
        
        {
          for $column in sql:execute(fn:concat("DESCRIBE ",$schema,".",$tablename),$samurl, ())/sql:tuple
          let $rawtype := $column/COLUMN_TYPE/text()
          let $basetype := fn:tokenize($rawtype,"\(")[1]
          let $xmltype := map:get($types,$basetype)
          return
            <m:column><m:name>{$column/COLUMN_NAME/text()}</m:name><m:rawtype>{$rawtype}</m:rawtype><m:xmltype>{$xmltype}</m:xmltype><m:nillable>{if ($column/IS_NULLABLE/text() = "NO") then fn:false() else fn:true()}</m:nillable></m:column>
        }</m:table>
    }
    {
      (: Fetch a list of relationships :)
      for $rel in sql:execute(fn:concat("SELECT ke.* FROM information_schema.KEY_COLUMN_USAGE ke WHERE ke.referenced_table_name IS NOT NULL and ke.TABLE_SCHEMA=""",$schema,""" ORDER BY ke.referenced_table_name"),$samurl, ())/sql:tuple
      return
        <m:relationship>
          <m:referencedtablename>{$rel/REFERENCED_TABLE_NAME/text()}</m:referencedtablename>
          <m:referencedcolumnname>{$rel/REFERENCED_COLUMN_NAME/text()}</m:referencedcolumnname>
          <m:tablename>{$rel/TABLE_NAME/text()}</m:tablename>
          <m:columnname>{$rel/COLUMN_NAME/text()}</m:columnname>
          <m:constraint>{$rel/CONSTRAINT_NAME/text()}</m:constraint>
        </m:relationship>
    }
  </m:schema-info>
};

(:



POST - Perform ingest of triples to the named graph
document config format (JSON or XML namespace same as extension lib)

{ingest: {
  database: {
    samurl: "http://kojak.marklogic.com:8080/mlsam/samurl",
    schema: "test2"
  },
  create: {
    graph: "mynamedgraph"
  },
  selection: {
    // Either: SCHEMA MODE NOT SUPPORTED - HANDLED AUTOMATICALLY WITH W3C DIRECT MAPPING IN DATA MODE
    mode: "schema", // Creates interdependencies between tables
    table: ["customers","policies","address"] // Other RD info required here
    
    // Or: 
    mode: "data",
    table: ["customers"], offset: 101, limit: 100, column: ["column1","column2"]
  },
  /* relationships are redundant - we look them up dynamically each call now 
  relationship: [ {
      tablename "t", columnname: "t", referencedtablename: "t", referencedcolumnname: "t", constraint: "t", 
    }, /* others */
  ]
  */
}
}

returns:-

{ingestresult: {
  docuri: ["/triplestore/2c78915c5854b0f8.xml", ... ],
  outcome: "success",
  statistics: {
    triplecount: 1034, rowcount: 100, entitycount: 100
  }
}
}


:)
declare function m:rdb2rdf-direct-partial($config as element(m:ingest)) as element(m:ingestresult) {
  (: Perform W3C direct mapping with specified index settings :)
  let $samurl := $config/m:database/m:samurl/text()
  let $schema := $config/m:database/m:schema/text()
  let $graph := $config/m:create/m:graph/text()
  let $tablename := $config/m:selection/m:table[1]/text()
  let $statsmap := map:map() (: triplecount as xs:integer, entitycount as xs:integer, rowcount as xs:integer ... :)
  let $so := map:put($statsmap,"triplecount",0)
  let $so := map:put($statsmap,"rowcount",0)
  let $so := map:put($statsmap,"entitycount",0)
  let $so := map:put($statsmap,"anoncount",0)
  let $sqlpk := fn:concat("SELECT ke.COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE ke WHERE ke.TABLE_SCHEMA=""" , $schema , """ AND ke.referenced_table_name IS NULL AND ke.table_name=""" , $tablename , """ ")
  let $l := xdmp:log($sqlpk)
  let $set := sql:execute($sqlpk,$samurl, ())
  let $l := xdmp:log("SQL OUTPUT:-")
  let $l := xdmp:log($set)
  let $primarykeycolumns := $set/sql:tuple/COLUMN_NAME/text()
  let $o := xdmp:log(fn:concat("PRIMARY KEY COLUMNS: ", $primarykeycolumns))
  let $sqlfk := fn:concat("SELECT ke.COLUMN_NAME,ke.REFERENCED_COLUMN_NAME,ke.REFERENCED_TABLE_NAME FROM information_schema.KEY_COLUMN_USAGE ke WHERE ke.TABLE_SCHEMA=""" , $schema , """ AND ke.referenced_table_name IS NOT NULL AND ke.table_name=""" , $tablename , """ ")
  let $l := xdmp:log($sqlfk)
  let $set2 := sql:execute($sqlfk,$samurl, ())
  let $l := xdmp:log("SQL OUTPUT 2:-")
  let $l := xdmp:log($set2)
  let $foreignkeycolumns := $set2/sql:tuple (: TODO restrict to only columns we have specified to import, not all fk relationships :)
  let $o := xdmp:log("FOREIGN KEY COLUMNS:- ")
  let $o := xdmp:log($foreignkeycolumns)
  let $pkcount := fn:count($primarykeycolumns)
  return
    <m:ingestresult>{
      (: MODE = table :)
      (: Perform ingest of a single table. No need to process tables without foreign keys first as the W3C direct mapping is consistent without this. :)
      (: Fetch appropriate data :)
      let $collist := fn:string-join( $config/m:selection/m:column/text(), ", " )
      let $base := fn:concat("http://marklogic.com/rdb2rdf/" , $schema , "/") (: RDF base: property :)
      
      let $sqldata := fn:concat("SELECT ", $collist, " FROM ",$schema,".",$tablename," ORDER BY ",$collist, " LIMIT ",$config/m:selection/m:offset/text(), ",", $config/m:selection/m:limit/text())
      let $l := xdmp:log($sqldata)
      let $data := sql:execute($sqldata,$samurl, ())/sql:tuple
      (: Generate our identity (if primary key exists) or temporary id (no primary key) :)
      let $objclass := fn:concat($base , m:rdfescape($tablename))
      let $put := map:put($statsmap,"rowcount",fn:count($data))
      let $triples :=
        for $row at $idx in $data
        let $o := xdmp:log(fn:concat("Row id: ", fn:string($idx)))
        let $rc := map:put($statsmap,"rowcount",map:get($statsmap,"rowcount") + 1)
        let $subject := 
          if ($pkcount gt 0) then fn:concat(
            $objclass , "/" , fn:concat(
              (: return COLNAME=colvalue with separating semi colon if a composite primary key :)
              for $pk at $pkidx in $primarykeycolumns
                let $l := xdmp:log(fn:concat("PK value: ", $pk))
              return
                ( fn:concat((
                  if ($pkidx gt 1) then ";" else 
                  fn:concat( m:rdfescape($pk) , "=" , m:rdfescape($row/element()[fn:local-name(.) = $pk]/text())))
                ))))
            
          else (
            let $nc := map:get($statsmap,"anoncount") + 1
            let $nnc := map:put($statsmap,"anoncount",$nc)
            return fn:concat(("_:a" , xs:string($nc))) (: TODO ensure this is consistent for multiple anon subjects with same _a index in same graph, added at different times :)
          )
        return (: per row :)
        (
          (sem:triple(sem:iri($subject), sem:iri("rdf:type"), sem:iri($objclass)),map:put($statsmap,"triplecount",map:get($statsmap,"triplecount") + 1),map:put($statsmap,"entitycount",map:get($statsmap,"entitycount") + 1))
        ,
          (: Process each column value :)
          for $col in $row/element()
          let $predicate := fn:concat($objclass , "#" , m:rdfescape($col/fn:local-name(.)))
          let $object := $col/text() (: TODO format the $object primitive such that the data type is carried through :)
      
          return
            (sem:triple(sem:iri($subject),sem:iri($predicate),sem:iri($object)),map:put($statsmap,"triplecount",map:get($statsmap,"triplecount") + 1))
        ,
          (: add any relationships to tables where we have foreign keys in our table columns :)
          for $reftablename in fn:distinct-values($foreignkeycolumns/REFERENCED_TABLE_NAME/text())
          let $tablefks := $foreignkeycolumns[./REFERENCED_TABLE_NAME/text() = $reftablename]
          let $tablefkcount := fn:count($tablefks)
          let $predicate := fn:concat(
            $objclass , "#ref-" , fn:concat(
            for $fkt at $fkidx in $tablefks
            let $colname := $fkt/COLUMN_NAME/text()
            let $refcolname := $fkt/REFERENCED_COLUMN_NAME/text()
            return
              if ($fkidx gt 1) then 
                ";" 
              else
                $colname ))
          let $object := fn:concat(
            $base , m:rdfescape($reftablename) , "/" , fn:concat(
            for $fkt at $fkidx in $tablefks
            let $colname := $fkt/COLUMN_NAME/text()
            let $refcolname := $fkt/REFERENCED_COLUMN_NAME/text()
            return
              if ($fkidx gt 1) then 
                ";" 
              else
                fn:concat($refcolname , "=" , $row/element()[fn:local-name(.) = $colname]/text())))
          return
            (sem:triple(sem:iri($subject),sem:iri($predicate),sem:iri($object)),map:put($statsmap,"triplecount",map:get($statsmap,"triplecount") + 1))
        )
      let $to := xdmp:log("TRIPLES:-")
      let $tripout := xdmp:log($triples)
      let $insertresult := sem:graph-insert(sem:iri($graph), $triples)
      let $l := xdmp:log("insert result:-")
      let $l := xdmp:log($insertresult)
      return (
        (: Commit this to a named graph rather than document so that MarkLogic handles the most performant storage mechanism :)
        <m:docuri>{$insertresult}</m:docuri>,
        <m:statistics>
          <m:triplecount>{map:get($statsmap,"triplecount")}</m:triplecount>
          <m:rowcount>{map:get($statsmap,"rowcount")}</m:rowcount>
          <m:entitycount>{map:get($statsmap,"entitycount")}</m:entitycount>
        </m:statistics>,
        <m:outcome>success</m:outcome>
        )
        (: return graph insert result doc IDs
  sem:graph-insert(sem:iri('bookgraph'), 
   sem:triple(sem:iri('urn:isbn:9780080540160'),
              sem:iri('http://purl.org/dc/elements/1.1/title'), 
              "Query XML,XQuery, XPath, and SQL/XML in context"))
        :)
        (: return result (with generation stats) :)
    }</m:ingestresult>
};

declare function m:rdfescape($str as xs:string) as xs:string {
  (: percent encode as per W3C RDB2RDF spec :)
  xdmp:url-encode($str,fn:true())
};
