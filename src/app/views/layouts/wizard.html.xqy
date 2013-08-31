(:
Copyright 2012 MarkLogic Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:)
xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

declare variable $view as item()* := vh:get("view");
declare variable $title as xs:string? := (vh:get('title'), "New Roxy Application")[1];
declare variable $sidebar as item()* := vh:get("sidebar");
declare variable $hiddenFormInput as item()* := vh:get("hiddenFormInput");


xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta charset="utf-8" />
    <title>kojak-mlsam</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content=""/>
    <meta name="author" content="jojrg"/>

    <!-- Le styles -->
    <link href="/css/bootstrap-roxy.css" rel="stylesheet"/>
    <link href="/css/mlsam-layout.less" rel="stylesheet/less"/>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="/js/lib/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
  </head>

  <body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar">&nbsp;</span>
            <span class="icon-bar">&nbsp;</span>
            <span class="icon-bar">&nbsp;</span>
          </button>
          <a class="navbar-brand" href="/mlsam.html">KoJAk</a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>


  <div class="container"> 
    {$view}
    <hr/>
      <footer>
        <p>© MarkLogic 2013</p>
      </footer>

  </div><!--/.container-fluid-->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/lib/jquery-1.7.1.min.js" type="text/javascript">&nbsp;</script>
    <script src="/js/lib/less-1.3.0.min.js" type="text/javascript">&nbsp;</script>
    <script src="/js/lib/bootstrap.js" type="text/javascript">&nbsp;</script>  
</body></html>