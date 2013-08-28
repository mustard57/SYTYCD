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
