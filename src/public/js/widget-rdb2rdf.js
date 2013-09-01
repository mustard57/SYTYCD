/*
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
*/
// global variable definitions
com = window.com || {};
com.marklogic = window.com.marklogic || {};
com.marklogic.widgets = window.com.marklogic.widgets || {};

/**
 * A widget that performs a W3C RDB2RDF Direct mapping. This is a wizard that steps you through the ingestion process.
 * 
 * NB Requires the rdb2rdf.xqy REST API resource extension supported by mljs.sam* methods
 * 
 * @constructor
 * @param {string} container - The HTML ID of the element to place this widget's content within.
 */
com.marklogic.widgets.rdb2rdf = function(container) {
  this.container = container;
  
  this._refresh();
};

com.marklogic.widgets.rdb2rdf.prototype._refresh = function() {
  // perform initial HTML drawing
  var s = "";
  
  // tab bar - feel free to replace with a widget of your choice (preferably not a large library required like jQuery)
  
  s += "<div class='row'>";
  s += "  <div class='col-md-9 col-md-offset-1'>";  
  s += "    <ol class='rdb2rdf-tabs breadcrumb'>";
  s += "      <li class='rdb2rdf-tab' id='" + this.container + "-step-1-tab' class='rdb2rdf-tab-selected active'><span class='label label-success'>Specify database connection</span></li>";
  s += "      <li class='rdb2rdf-tab' id='" + this.container + "-step-2-tab'>Select Schema</li>";
  s += "      <li class='rdb2rdf-tab' id='" + this.container + "-step-3-tab'>Select tables</li>";
  s += "      <li class='rdb2rdf-tab' id='" + this.container + "-step-4-tab'>Perform import</li>";
  s += "      <li class='rdb2rdf-tab' id='" + this.container + "-complete'>Complete</li>";
  s += "    </ol>";
  s += "  </div>";
  s += "</div>";
  
  s += "<div class='rdb2rdf-steps row'>";
  
  // Step panes
    
  s += "<div id='" + this.container + "-step-1' class='col-md-9 col-md-offset-1'>"; // intro / enter SAM URL
  s += " <p class='lead'>Please enter a MarkLogic SAM endpoint URL that is connected to your database server...</p>";

  s += " <form class='form-horizontal' role='form'>";
  s += "   <div class='form-group'>";
  s += "     <label for='" + this.container + "-mlsam' class='col-lg-2 control-label'>MarkLogic SAM URL:</label>";
  s += "     <div class='col-lg-2'>";
  s += "       <input type='url' class='form-control' id='" + this.container + "-mlsam' placeholder='MarkLogic SAM URL...'>";
  s += "     </div>";
  s += "   </div>";
  s += "   <div class='form-group'>";
  s += "     <div class='col-lg-offset-2 col-lg-10'>";
  s += "       <button type='submit' id='" + this.container + "-step-1-next' class='btn btn-primary'>Next &rarr;</button>";
  s += "     </div>";
  s += "   </div>";
  s += " </form>";
  s += "</div>";
  
  s += "<div id='" + this.container + "-step-2' class='hidden'>"; // list and select schema to import
  s += "  <p>Select a Schema to import and click Next.</p>";
  s += "  <p><select id='" + this.container + "-schema-select'><option value=''>None</option></select></p>";
  s += "  <p class='rdb2rdf-submit' id='" + this.container + "-step-2-next'>Next...</p>";
  s += "</div>";
  
  
  s += "<div id='" + this.container + "-step-3' class='hidden'>"; // list tables and relationships with metrics (row count), and select which tables to import (relationships are automatically added)
  
  s += "</div>";
  
  
  s += "<div id='" + this.container + "-step-4' class='hidden'>"; // Perform the import sequence, table by table, 100 rows at a time, showing a progress bar widget, or even better a list where green ticks appear when each step is done. NB steps must be done in order
  
  s += "</div></div>";
  
  document.getElementById(this.container).innerHTML = s; // single hit for DOM performance
  
  // Add onclick handlers as appropriate
  var self = this;
  document.getElementById(this.container + "-step-1-next").onclick = function(e) {self._processStep1();e.stopPropagation();return false;};
  
  document.getElementById(this.container + "-step-1-tab").onclick = function(e) {self._showStep1();e.stopPropagation();return false;};
  document.getElementById(this.container + "-step-2-tab").onclick = function(e) {self._showStep2();e.stopPropagation();return false;};
  document.getElementById(this.container + "-step-3-tab").onclick = function(e) {self._showStep3();e.stopPropagation();return false;};
  document.getElementById(this.container + "-step-4-tab").onclick = function(e) {self._showStep4();e.stopPropagation();return false;};
};

com.marklogic.widgets.rdb2rdf.prototype._processStep1 = function() {
  // do nothing now, just show step 2	
  this._showStep2();
};

com.marklogic.widgets.rdb2rdf.prototype._showStep1 = function() {
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-1"),false);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-2"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-3"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-4"),true);
};

com.marklogic.widgets.rdb2rdf.prototype._showStep2 = function() {
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-1"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-2"),false);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-3"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-4"),true);
  
  // refresh schema list
  var self = this;
  mljs.defaultconnection.samListSchema(document.getElementById(this.container + "-mlsam").value,function(result) {
    var schemas = result.doc["list-schema"].schema;
    var s = "";
    for (var i = 0, max = schemas.length;i < max;i++) {
      s += "<option value='" + schemas[i] + "'>" + schemas[i] + "</option>";
    }
    document.getElementById(self.container + "-schema-select").innerHTML = s;
  });
};

com.marklogic.widgets.rdb2rdf.prototype._showStep3 = function() {
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-1"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-2"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-3"),false);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-4"),true);
  
  // TODO step 3 display actions
};

com.marklogic.widgets.rdb2rdf.prototype._showStep4 = function() {
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-1"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-2"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-3"),true);
  com.marklogic.widgets.hide(document.getElementById(this.container + "-step-4"),false);
  
  // TODO step 4 display actions
};


  


