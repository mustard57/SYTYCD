xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

declare option xdmp:mapping "false";


   
vh:add-value("hiddenFormInput",()),
vh:add-value("sidebar",()),
<div class="jumbotron">
    <h1>Banking durch Technik</h1>
    <p class="lead">... acquired by Joerg Enterprises in 2013, National Kensington Bank is a venerable British financial institution dating back to early 2013. It hit the headlines in late 2013 due to it's adoption of a revolutionary new technology.</p>
    <p class="lead">Explore Ken from Kensignton's wonderland of triples and his mission to unlock data into an Enterprise NoSQL database.  </p>
    <p><span id='welcome-search-button'><a class="btn btn-lg btn-success" href="/mlsam/rdb2rdf">Import from RDB</a></span><span class="lead"> or </span><span id='welcome-search-button'><a class="btn btn-lg btn-success" href="/mlsam/sparql">Search Triples</a></span></p>
</div>  
   