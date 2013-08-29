xquery version "1.0-ml";

module namespace ext = "http://marklogic.com/rest-api/resource/rdb2rdf";

import module namespace m = "http://marklogic.com/roxy/models/rdb2rdf" at "/app/models/rdb2rdf-lib.xqy";
import module namespace config = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";
import module namespace json6 = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare namespace roxy = "http://marklogic.com/roxy";

(: 
 : To add parameters to the functions, specify them in the params annotations. 
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") ext:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :)

(:
 :)
declare 
%roxy:params("samurl=xs:string","schema=xs:string")
function ext:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  let $preftype := if ("application/xml" = map:get($context,"accept-types")) then "application/xml" else "application/json"
  let $out := 
    if (fn:empty(map:get($params,"schema"))) then
      (: list all schema :)
      m:list-schema(map:get($params,"samurl"))
    else 
      (: get specific schema info :)
      m:get-schema-info(map:get($params,"samurl"), map:get($params,"schema"))
  let $outlog := map:put($context, "output-types", $preftype)
  return
  (
    xdmp:set-response-code(200, "OK"),
    document {
      if ("application/xml" = $preftype) then 
        $out
      else 
        let $config := json:config("custom") 
        let $cx := map:put( $config, "text-value", "label" )
        let $cx := map:put( $config , "camel-case", fn:false() )
        let $cx := map:put($config, "array-element-names",(xs:QName("m:schema"),xs:QName("m:table"),xs:QName("m:column"),xs:QName("m:relationship")))
        let $cx := map:put($config, "element-namespace","http://marklogic.com/roxy/models/rdb2rdf")
        return
          json6:transform-to-json($out,$config)
    }
  )
};

(:
 :)
declare 
%roxy:params("")
function ext:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()*
{
  map:put($context, "output-types", "application/xml"),
  xdmp:set-response-code(200, "OK"),
  document { "POST called on the ext service extension" }
};

