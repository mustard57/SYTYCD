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

com.marklogic.widgets.docsemlink = function(container) {
  this.container = container;
  
  this.refresh();
};

com.marklogic.widgets.docsemlink.prototype.refresh = function() {
  var s = "<a href='#' id='" + this.container + "-docsemlink' class='hidden'>View Customer Report</a>";
  document.getElementById(this.container).innerHTML = s;
  
  var self = this;
  document.getElementById(this.container + "-docsemlink").onclick = function(e) {
    self._showSemanticInfo();
    
    e.stopPropagation();
    return false;
  };
}

com.marklogic.widgets.docsemlink.prototype.setContext = function(cc) {
  this.context = cc;
};

com.marklogic.widgets.docsemlink.prototype.setSemanticContext = function(sc) {
  this.semanticcontext = sc;
};

com.marklogic.widgets.docsemlink.prototype.setKratu = function(k) {
  this.kratu = k;
};

com.marklogic.widgets.docsemlink.prototype.updateResults = function(results) {
  mljs.defaultconnection.logger.debug("docsemlink.updateResults: results: " + JSON.stringify(results) + ", typeof: " + (typeof results));
  // if results, then show link back
  // otherwise, hide us
  if (undefined == results || "boolean" == typeof results) {
    com.marklogic.widgets.hide(document.getElementById(this.container+"-docsemlink"),true);
  } else {
    this.uris = new Array();
    for (var i = 0, max = results.results.length, res; i < max;i++) {
      res = results.results[i];
      mljs.defaultconnection.logger.debug("docsemlink.updateResults: uri: " + res.uri);
      if (!this.uris.contains(res.uri)) {
        this.uris.push(res.uri);
      }
    }
    
    com.marklogic.widgets.hide(document.getElementById(this.container+"-docsemlink"),false);
  }
};

com.marklogic.widgets.docsemlink.prototype._showSemanticInfo = function() {
  // get content context query
  // use OUR semantic context to find links back to customers
  var sparql = "SELECT distinct ?jc ?fullname ?nicclientid ?nkbcustomerid ?nkbaccountsortcode ?nkbaccountnumber ?nkbaccountbalance WHERE {\n";
  sparql += "  ?jc a <http://www.ourcompany.com/ontology/JointCustomer> .\n";
  sparql += "  ?jc <http://www.ourcompany.com/ontology/NationalKensingtonBank/CUSTOMER> ?nkbcustomer .\n";
  sparql += "  ?jc <http://www.ourcompany.com/ontology/NewInsuranceCo/CLIENT> ?nicclient .\n";
  sparql += "  ?jc <http://www.ourcompany.com/ontology/JointCustomer/name> ?fullname .\n";
  sparql += "  ?nicclient <http://marklogic.com/semantics/ontology/mentioned_in> ?docuri .\n";
  sparql += "  FILTER (?docuri IN (";
  
  // specify URI restrictions
  for (var i = 0, max = this.uris.length;i < max;i++) {
    if (i > 0) {
      sparql += ",";
    }
    sparql += "<" + this.uris[i] + ">";
  }
  
  sparql += ")) . \n";
  sparql += "  ?nicclient <http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#CLIENT_ID> ?nicclientid . \n";
  sparql += "  ?nkbcustomer <http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-ACCOUNT_ID> ?nkbaccount .\n";
  sparql += "  ?nkbcustomer <http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#CUSTOMER_ID> ?nkbcustomerid .\n"; 
  sparql += "  ?nkbaccount <http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#BALANCE> ?nkbaccountbalance .\n";
  sparql += "  ?nkbaccount <http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#SORT-CODE> ?nkbaccountsortcode . \n";
  sparql += "  ?nkbaccount <http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-NUMBER> ?nkbaccountnumber . \n";
  sparql += "}";
  
  mljs.defaultconnection.logger.debug("docsemlink._showSemanticInfo: sparql: \n" + sparql);
  
  this.semanticcontext.queryFacts(sparql);
  
  // map sparql results to kratu - auto via context
  
  // show kratu widget
  com.marklogic.widgets.hide(document.getElementById(this.kratu),false);
};

