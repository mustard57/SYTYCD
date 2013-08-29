xquery version "1.0-ml";

module namespace m = "http://marklogic.com/roxy/models/rdb2rdf";

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
  tables: [
    {table: {
      name: "customers", 
      columns: [{column: { name: "custnum", rawtype: "int(11)", xmltype: "xs:integer", nillable: false}}, /* others */],
      metrics: {rowcount: 143}
    }}, // others ...
  ],
  relationships: [
    {relationship: {
      table: "t", column: "t", referencedtable: "t", referencedcolumn: "t", constraint: "t", 
    }}, /* others */
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

declare function m:rdb2rdf-direct-partial($samurl as xs:string,$schema as xs:string,$tablename as xs:string,$offset as xs:integer,$limit as xs:integer,$namedgraph as xs:string) {
  ()
};