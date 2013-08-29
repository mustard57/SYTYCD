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

<div xmlns="http://www.w3.org/1999/xhtml" class="mlsam rdb2rdf">

<link rel="stylesheet" type="text/css" href="/css/widgets.css" />
<script type="text/javascript" src="/js/mljs.js"></script>
<script type="text/javascript" src="/js/mljs-xhr2.js"></script>

<script type="text/javascript" src="/js/widgets.js"></script>
<script type="text/javascript" src="/js/widget-rdb2rdf.js"></script>

<script type="text/javascript" src="/js/page-mlsam-rdb2rdf.js"></script>
  
 <div class="container_12">  
  <div id="errors" class="grid_12"></div>
 </div>
 <div class="container_12">  
  <div id="rdb2rdf" class="grid_12 rdb2rdf">RDB2RDF html here</div>
 </div>
  
</div>