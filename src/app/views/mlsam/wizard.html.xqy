xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

declare option xdmp:mapping "false";

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

vh:add-value("rdb2rdfWizard",()),
<div class="wizard">     
    <ol class="breadcrumb">
      <li>Specify database connection</li>
      <li>Select Schema</li>
      <li class="active"><span class="label label-primary">Select Tables</span></li>
    </ol>
</div>