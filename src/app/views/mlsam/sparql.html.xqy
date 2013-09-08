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

vh:add-value("hiddenFormInput",()),
vh:add-value("sidebar",()),
<div xmlns="http://www.w3.org/1999/xhtml" class="mlsam sparql">

<link rel="stylesheet" type="text/css" href="/css/widgets.css" />
<link rel="stylesheet" type="text/css" href="/css/kratu.css" />
<link rel="stylesheet" type="text/css" href="/css/page-mlsam-sparql.css" />
<link rel="stylesheet" type="text/css" href="/css/960/960.css" />
<script type="text/javascript" src="/js/lib/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/js/mljs.js"></script>
<script type="text/javascript" src="/js/mljs-xhr2.js"></script>

<script type="text/javascript" src="/js/widgets.js"></script>
<script type="text/javascript" src="/js/kratu.js"></script>
<script type="text/javascript" src="/js/dataproviders/json.js"></script>
<script type="text/javascript" src="/js/widget-search.js"></script>
<script type="text/javascript" src="/js/widget-triples.js"></script>
<script type="text/javascript" src="/js/widget-kratu.js"></script>
<script type="text/javascript" src="/js/widget-docsemlink.js"></script>

<script type="text/javascript" src="/js/page-mlsam-sparql.js"></script>
  
 <div class="container_12">  
  <div id="errors" class="grid_12"></div>
 </div>
 <div class="container_12">  
  <div id="query" class="grid_12 sparqlpage-bar">query</div>
 </div>
 <div class="container_12">  
  <div id="triple-content" class="triple-page grid_4">Triple results goes here</div>
  <div id="facts" class="triple-page grid_4">Facts go here</div>
  <div id="allcontent" class="grid_4"><div class="container_4">
   <div class='mljswidget grid_4'><h2 class='title'>Related Documents</h2></div>
   <div id="search-bar" class="grid_4">Bar</div>
   <div id="search-content" class="search-page grid_4">Search content goes here</div>
   <div class='mljswidget grid_4' id='docsemlink'>dsl</div>
  </div></div>
 </div>
 <div class="container_12"> 
   <div id="kratu" class="grid_12 hidden"></div>
 </div>
</div>