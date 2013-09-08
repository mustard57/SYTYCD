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

module namespace c = "http://marklogic.com/roxy/config";

import module namespace def = "http://marklogic.com/roxy/defaults" at "/roxy/config/defaults.xqy";

declare namespace rest = "http://marklogic.com/appservices/rest";


declare variable $DEFAULT-CONTROLLER := "/mlsam/index.html";


(:
 : ***********************************************
 : Overrides for the Default Roxy control options
 :
 : See /roxy/config/defaults.xqy for the complete list of stuff that you can override.
 : Roxy will check this file (config.xqy) first. If no overrides are provided then it will use the defaults.
 :
 : Go to https://github.com/marklogic/roxy/wiki/Overriding-Roxy-Options for more details
 :
 : ***********************************************
 :)
declare variable $c:ROXY-OPTIONS :=
  <options>
    <layouts>
      <layout format="html">three-column</layout>
    </layouts>
  </options>;

(:
 : ***********************************************
 : Overrides for the Default Roxy scheme
 :
 : See /roxy/config/defaults.xqy for the default routes
 : Roxy will check this file (config.xqy) first. If no overrides are provided then it will use the defaults.
 :
 : Go to https://github.com/marklogic/roxy/wiki/Roxy-URL-Rewriting for more details
 :
 : ***********************************************
 :)
declare variable $c:ROXY-ROUTES :=
  <routes xmlns="http://marklogic.com/appservices/rest">
    <request uri="^/my/awesome/route" />
  	      <request uri="^/$" endpoint="/roxy/query-router.xqy">
  	        <uri-param name="controller">mlsam</uri-param>
  	        <uri-param name="func">index</uri-param>
  	        <uri-param name="format">html</uri-param>
  	        <http method="GET"/>
  	        <http method="HEAD"/>
  	      </request>
    <request uri="^/fonts/(.*)" endpoint="/public/fonts/$1"/>    
    {
      $def:ROXY-ROUTES/rest:request
    }
  </routes>;

(:
 : ***********************************************
 : A decent place to put your appservices search config
 : and various other search options.
 : The examples below are used by the appbuilder style
 : default application.
 : ***********************************************
 :)
 
 
(: URL for the MLSAM servlet container application:) 
declare variable $MLSAM-URL :=  "http://kojak.demo.marklogic.com:8080/mlsam/mlsql";
 
 
 
declare variable $c:DEFAULT-PAGE-LENGTH as xs:int := 5;

declare variable $c:SEARCH-OPTIONS :=
  <options xmlns="http://marklogic.com/appservices/search">
    <search-option>unfiltered</search-option>
    <term>
      <term-option>case-insensitive</term-option>
     </term>
     <!-->
     <constraint name="list">
       <range type="xs:string" collation="http://marklogic.com/collation/codepoint" facet="true">
        <element ns="" name="message"/>
        <attribute ns="" name="list"/>
         <facet-option>limit=10</facet-option>
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
      </range>
     </constraint>
     <constraint name="author">
       <range type="xs:string" collation="http://marklogic.com/collation/codepoint" facet="true">
        <element ns="" name="from"/>
        <attribute ns="" name="address"/>
        <facet-option>limit=10</facet-option>
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
      </range>
     </constraint>
-->
    <return-results>true</return-results>
    <return-query>true</return-query>
  </options>;

(:
 : Labels are used by appbuilder faceting code to provide internationalization
 :)
declare variable $c:LABELS :=
  <labels xmlns="http://marklogic.com/xqutils/labels">
    <label key="list">
      <value xml:lang="en">Email Lists</value>
    </label>
    <label key="author">
      <value xml:lang="en">Authors</value>
    </label>
  </labels>;
