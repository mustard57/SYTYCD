xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
declare namespace sql  = "http://xqdev.com/sql";

declare option xdmp:mapping "false";


declare variable $mlsamResponse as element(sql:result)? := vh:get("mlsamResponse");

(: use the vh:required method to force a variable to be passed. it will throw an error
 : if the variable is not provided by the controller :)
(:
  declare variable $title as xs:string := vh:required("title");
    or
  let $title as xs:string := vh:required("title");
:)

(: grab optional data :)
(:
  declare variable $stuff := vh:get("stuff");
    or
  let $stuff := vh:get("stuff")
:)


vh:add-value("hiddenFormInput",()),
vh:add-value("sidebar",()),
<table class="table">
 <thead>
   <tr>
    <th>Count</th>
   </tr>
 </thead>
 <tbody>
 {
  for $i in $mlsamResponse/sql:tuple
  return
          <tr>
            <td>{$i/CNT/text()}</td>
          </tr>
 }         
 <tr><td>Errors:-</td></tr>
 {
   for $e in $mlsamResponse/sql:meta/sql:exceptions/sql:exception/sql:reason/text()
   return
    <tr><td>{$e}</td></tr>
 }
  </tbody>
 </table>
