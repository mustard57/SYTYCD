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

<div xmlns="http://www.w3.org/1999/xhtml" class="mlsam explore">

<link rel="stylesheet" type="text/css" href="/css/widgets.css" />
<link rel="stylesheet" type="text/css" href="/css/kratu.css" />
<link rel="stylesheet" type="text/css" href="/css/960/960.css" />
<script type="text/javascript" src="/js/lib/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/js/mljs.js"></script>
<script type="text/javascript" src="/js/mljs-xhr2.js"></script>

<script type="text/javascript" src="/js/highcharts.js"></script>
<script type="text/javascript" src="/js/widgets.js"></script>

<script type="text/javascript" src="/js/kratu.js"></script>
<script type="text/javascript" src="/js/dataproviders/json.js"></script>
<script type="text/javascript" src="/js/widget-search.js"></script>
<script type="text/javascript" src="/js/widget-triples.js"></script>
<script type="text/javascript" src="/js/widget-kratu.js"></script>
<script type="text/javascript" src="/js/widget-explore.js"></script>
<script type="text/javascript" src="/js/page-mlsam-explore.js"></script>
  
 <div class="container_12">  
  <div id="errors" class="grid_12"></div>
 </div>
 <div class="container_12">  
  <div id="triple-content" class="triple-page grid_6">Triple results goes here</div>
 </div>
 <div class="container_12">  
  <div id="explorer" class="grid_12">Explorer</div>
 </div>
 <div class="container_12"> 
   <div id="kratu" class="grid_12 hidden"></div>
 </div>
</div>