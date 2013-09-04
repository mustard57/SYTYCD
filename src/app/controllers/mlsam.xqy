xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/mlsam";

(: the controller helper library provides methods to control which view and template get rendered :)
import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";
import module namespace sql  = "http://xqdev.com/sql" at "/app/models/sql.xqy";
(: The request library provides awesome helper methods to abstract get-request-field :)
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";
import module namespace config = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";



declare option xdmp:mapping "false";

(:
 : Usage Notes:
 :
 : use the ch library to pass variables to the view
 :
 : use the request (req) library to get access to request parameters easily
 :
 :)
declare function c:main() as item()*
{
  let $sqlQuery := "select * from test2.player,test2.team where player.team_idteam = team.idteam"
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:describe() as item()*
{
  let $sqlQuery := "DESCRIBE test2.player" (: Describes structure of player table :)
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:showfull() as item()*
{
  let $sqlQuery := "SHOW FULL TABLES FROM test2" (: Lists whether a view or a table (full) :)
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:showindex() as item()*
{
  let $sqlQuery := "SHOW INDEX FROM test2.player" (: Show all indexes fields in player, not just fk/pk :)
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:relationships() as item()*
{ (: SELECT ke.referenced_table_name parent, ke.table_name child, ke.constraint_name :)
  let $sqlQuery := "SELECT ke.* FROM information_schema.KEY_COLUMN_USAGE ke WHERE ke.referenced_table_name IS NOT NULL and ke.TABLE_SCHEMA=""test2"" ORDER BY ke.referenced_table_name" (: Show only fk/pk on all tables in schema. Very MySQL specific. :)
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
  
};

declare function c:listschema() as item()*
{ (: SELECT ke.referenced_table_name parent, ke.table_name child, ke.constraint_name :)
  let $sqlQuery := "SELECT DISTINCT ke.TABLE_SCHEMA FROM information_schema.KEY_COLUMN_USAGE ke ORDER BY ke.TABLE_SCHEMA " 
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:rdb2rdf() as item()*
{(
  ch:use-view((), "xml"),
  ch:use-layout(("wizard-layout"), "html"))
};



declare function c:primarykeys() as item()*
{ (: SELECT ke.referenced_table_name parent, ke.table_name child, ke.constraint_name :)
  (: let $sqlQuery := "SELECT ke.* FROM information_schema.KEY_COLUMN_USAGE ke WHERE ke.TABLE_SCHEMA=""test2""" :)
  let $sqlQuery := "SELECT ke.* FROM information_schema.KEY_COLUMN_USAGE ke WHERE ke.TABLE_SCHEMA=""NewInsuranceCo"" AND ke.referenced_table_name IS NULL AND ke.table_name=""CONTRACT"" "
  return
  ch:add-value("mlsamResponse", sql:execute($sqlQuery, $config:MLSAM-URL, ())),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};


declare function c:countsytycd() as item()*
{ (: SELECT ke.referenced_table_name parent, ke.table_name child, ke.constraint_name :)
  let $sqlQuery := "SELECT COUNT(CUSTOMER_ID) CNT FROM SYTYCD.CUSTOMER " 
  let $l := xdmp:log("COUNTSYTYCD")
  let $mlsamResponse := sql:execute($sqlQuery, $config:MLSAM-URL, ())
  let $l := xdmp:log($mlsamResponse)
  return
  ch:add-value("mlsamResponse", $mlsamResponse),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:countnkb() as item()*
{ (: SELECT ke.referenced_table_name parent, ke.table_name child, ke.constraint_name :)
  let $sqlQuery := "SELECT COUNT(CUSTOMER_ID) CNT FROM NationalKensingtonBank.CUSTOMER " 
  let $l := xdmp:log("COUNTNKB")
  let $mlsamResponse := sql:execute($sqlQuery, $config:MLSAM-URL, ())
  let $l := xdmp:log($mlsamResponse)
  return
  ch:add-value("mlsamResponse", $mlsamResponse),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:countnic() as item()*
{ (: SELECT ke.referenced_table_name parent, ke.table_name child, ke.constraint_name :)
  let $sqlQuery := "SELECT COUNT(*) CNT FROM NewInsuranceCo.CLIENT " 
  let $l := xdmp:log("COUNTNIC")
  let $mlsamResponse := sql:execute($sqlQuery, $config:MLSAM-URL, ())
  let $l := xdmp:log($mlsamResponse)
  return
  ch:add-value("mlsamResponse", $mlsamResponse),
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};

declare function c:sparql() as item()*
{
  ch:use-view((), "xml"),
  ch:use-layout(("mlsam"), "html")
};
