
$(document).ready(function() {
  var db = new mljs();
  db.logger.setLogLevel("debug");
  
  var error = new com.marklogic.widgets.error("errors");
  
  try {
  var tripleconfig = new com.marklogic.semantic.tripleconfig();
  /*
  
com.marklogic.semantic.tripleconfig.prototype.addMovies = function() {
  this.validTriples.push({subjectType: "person", objectType: "movie", predicateArray: ["likesmovie"]});
  
  this._newentities["movie"] = {name: "movie", title: "Movie", prefix: "http://marklogic.com/semantic/ns/movie", iriPattern: "http://marklogic.com/semantic/targets/movies/#VALUE#",
    rdfTypeIri: "http://marklogic.com/semantic/rdfTypes/movie", rdfTypeIriShort: "mov:movie", commonNamePredicate: "hastitle",
    properties: [
      {name: "hastitle", iri: "hastitle", shortiri: "mov:hastitle"},
      {name: "hasactor", iri: "hasactor", shortiri: "mov:hasactor"},
      {name: "hasgenre", iri: "hasgenre", shortiri: "mov:hasgenre"},
      {name: "releasedin", iri: "releasedin", shortiri: "mov:releasedin"}
    ]
  };
  this._newPredicates["likesmovie"] = {name: "likesmovie", title: "Likes movie", iri: "likesmovie", shortiri: "mov:likesmovie"};
  this._newPredicates["hastitle"] = {name: "hastitle", title: "Has Title", iri: "hastitle", shortiri: "mov:hastitle"};
  this._newPredicates["hasactor"] = {name: "hasactor", title: "Has Actor", iri: "hasactor", shortiri: "mov:hasactor"};
  this._newPredicates["hasgenre"] = {name: "hasgenre", title: "Has Genre", iri: "hasgenre", shortiri: "mov:hasgenre"};
  this._newPredicates["releasedin"] = {name: "releasedin", title: "Released In", iri: "releasedin", shortiri: "mov:releasedin"};
};
*/
  var jointEntity = {
    name: "jointcustomer", title: "Joint Customer", prefix: "http://www.ourcompany.com/ontology/JointCustomer", iriPattern: "http://www.ourcompany.com/ontology/JointCustomer/#VALUE#",
    rdfTypeIri: "http://www.ourcompany.com/ontology/JointCustomer", rdfTypeIriShort: "joint:customer", commonNamePredicate: "http://www.ourcompany.com/ontology/JointCustomer/name",
    properties: [
      {name: "nicclient", iri: "http://www.ourcompany.com/ontology/NewInsuranceCo/CLIENT", shortiri: "nic:client"},
      {name: "nkbcustomer", iri: "http://www.ourcompany.com/ontology/NationalKensingtonBank/CUSTOMER", shortiri: "nkb:customer"},
      {name: "jointname", iri: "http://www.ourcompany.com/ontology/JointCustomer/name", shortiri: "joint:name"}
    ]
  };
  var jointPredicates = new Array();
  jointPredicates["nic_client"] = {name: "nic_client", title: "Is New Insurance Co Client", iri: "http://www.ourcompany.com/ontology/NewInsuranceCo/CLIENT", shortiri: "nic:client"};
  jointPredicates["nkb_customer"] = {name: "nkb_customer", title: "Is National Kensington Bank Customer", iri: "http://www.ourcompany.com/ontology/NationalKensingtonBank/CUSTOMER", shortiri: "nic:client"};
  jointPredicates["jointname"] = {name: "jointname", title: "Has Full Name", iri: "http://www.ourcompany.com/ontology/JointCustomer/name", shortiri: "joint:name"};
  
  var jointTriples = [
    {subjectType: "jointcustomer", objectType: "nicclient", predicateArray: ["nic_client"]},
    {subjectType: "jointcustomer", objectType: "nkbcustomer", predicateArray: ["nkb_customer"]}
  ];
  
  
  var nicClientEntity = {
    name: "nicclient", title: "NIC Client", prefix: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT", iriPattern: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT/CLIENT_ID=#VALUE#",
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT", rdfTypeIriShort: "nic:client", commonNamePredicate: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FAMILY_NAME",
    properties: [
      {name: "clientid", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#CLIENT_ID", shortiri: "nic:client_id"},
      {name: "title", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#TITLE", shortiri: "nic:title"},
      {name: "firstname", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FIRST_NAME", shortiri: "nic:firstname"},
      {name: "familyname", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FAMILY_NAME", shortiri: "nic:familyname"},
      {name: "dob", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#DOB", shortiri: "nic:dob"},
      {name: "profession", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PROFESSION", shortiri: "nic:profession"}
    ]
  };
  var nicClientPredicates = new Array();
  nicClientPredicates["clientid"] = {name: "clientid", title: "Has Client ID", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#CLIENT_ID", shortiri: "nic:client_id"};
  nicClientPredicates["title"] = {name: "title", title: "Has Title", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#TITLE", shortiri: "nic:title"};
  nicClientPredicates["firstname"] = {name: "firstname", title: "Has First Name", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FIRST_NAME", shortiri: "nic:firstname"};
  nicClientPredicates["familyname"] = {name: "familyname", title: "Has Family Name", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FAMILY_NAME", shortiri: "nic:familyname"};
  nicClientPredicates["dob"] = {name: "dob", title: "Has Date of Birth", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#DOB", shortiri: "nic:dob"};
  nicClientPredicates["profession"] = {name: "profession", title: "Has Profession", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PROFESSION", shortiri: "nic:profession"};
  nicClientPredicates["nic_address"] = {name: "nic_address", title: "Has Address", iri:"http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#ref-ADDRESS_ID"};
  
  var nicClientTriples = [
    {subjectType: "nicclient", objectType: "nicaddress", predicateArray: ["nic_address"]}
  ];

  var nicAddressEntity = {
    name: "nicaddress", title: "Address", prefix: "http://marklogic.com/rdb2rdf/NewInsuranceCo/ADDRESS", iriPattern: "http://marklogic.com/rdb2rdf/NewInsuranceCo/ADDRESS/ADDRESS_ID=#VALUE#",
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/ADDRESS", commonNamePredicate: "http://marklogic.com/rdb2rdf/NewInsuranceCo/ADDRESS/LINE_1",
    properties: [
      {name: "line_1", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/ADDRESS/LINE_1"}
    ]
  };
  var nicAddressPredicates = new Array();
  nicAddressPredicates["line_1"] = {name: "line_1", title: "Has First Line", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/ADDRESS/LINE_1"};
  var nicAddressTriples = new Array();
  
  var nkbCustomerEntity = {
    name: "nkbcustomer", title: "NKB Customer", prefix: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER", iriPattern: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER/CUSTOMER_ID=#VALUE#",
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER", commonNamePredicate: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER/SURNAME",
    properties: [
      {name: "customer_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER/CUSTOMER_ID"},
      {name: "account_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT_ID"},
      {name: "account-number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-NUMBER"},
      {name: "sort-code", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/SORT-CODE"},
      {name: "account-status_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-STATUS_ID"},
      {name: "account-type_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-TYPE_ID"},
      {name: "balance", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/BALANCE"},
      {name: "title", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/TITLE"},
      {name: "first_name", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/FIRST_NAME"},
      {name: "surname", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/SURNAME"}
    ] 
  };
  var nkbCustomerPredicates = new Array();
  nkbCustomerPredicates["customer_id"] = {name: "customer_id", title: "Has Customer ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER/CUSTOMER_ID"};
  nkbCustomerPredicates["account_id"] = {name: "account_id", title: "Has Account ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT_ID"};
  nkbCustomerPredicates["account-number"] = {name: "account-number", title: "Has Account Number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-NUMBER"};
  nkbCustomerPredicates["sort-code"] = {name: "sort-code", title: "Has Sort Code", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/SORT-CODE"};
  nkbCustomerPredicates["account-status_id"] = {name: "account-status_id", title: "Has Account Status ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-STATUS_ID"};
  nkbCustomerPredicates["account-type_id"] = {name: "account-type_id", title: "Has Account Type ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-TYPE_ID"};
  nkbCustomerPredicates["balance"] = {name: "balance", title: "Has Balance", ri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/BALANCE"};
  nkbCustomerPredicates["title"] = {name: "title", title: "Has Title", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/TITLE"};
  nkbCustomerPredicates["first_name"] = {name: "first_name", title: "Has First Name", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/FIRST_NAME"};
  nkbCustomerPredicates["surname"] = {name: "surname", title: "Has Surname", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/SURNAME"};
  var nkbCustomerTriples = [
  ];
  
  var nkbAccountEntity = {
    name: "nkbaccount", title: "NKB Account", prefix: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT", iriPattern: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT_ID=#VALUE#",
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT", commonNamePredicate: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-NUMBER",
    properties: [
      {name: "account_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT_ID"},
      {name: "account-number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-NUMBER"},
      {name: "sort-code", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/SORT-CODE"},
      {name: "account-status_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-STATUS_ID"},
      {name: "account-type_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT-TYPE_ID"},
      {name: "customer_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/CUSTOMER_ID"},
      {name: "balance", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/BALANCE"},
    ] 
  };
  var nkbAccountPredicates = new Array();
  var nkbAccountTriples = [
  ];
  
  db.logger.debug("ENTITY: " + JSON.stringify(jointEntity));
  db.logger.debug("PREDICATES: " + JSON.stringify(jointPredicates));
  db.logger.debug("TRIPLES: " + JSON.stringify(jointTriples));
  
  tripleconfig.addMappings("jointcustomer",jointEntity, jointPredicates, jointTriples);
  tripleconfig.addMappings("nicclient",nicClientEntity, nicClientPredicates, nicClientTriples);
  tripleconfig.addMappings("nicaddress",nicAddressEntity, nicAddressPredicates, nicAddressTriples);
  tripleconfig.addMappings("nkbcustomer",nkbCustomerEntity, nkbCustomerPredicates, nkbCustomerTriples);
  tripleconfig.addMappings("nkbaccount",nkbAccountEntity, nkbAccountPredicates, nkbAccountTriples);
  
  var semctx = new db.semanticcontext();
  semctx.setConfiguration(tripleconfig);
  var contentctx = new db.searchcontext();
  semctx.setContentContext(contentctx);
 
  var wgt = new com.marklogic.widgets.searchresults("search-content");
  contentctx.register(wgt);
  //wgt.addErrorListener(error.updateError);
  //wgt.bar.setTransform("redaction");
  //wgt.bar.setFormat("xml"); // redaction transform will convert to JSON
  
  var tripResults = new com.marklogic.widgets.sparqlresults("triple-content");
  semctx.register(tripResults);
  //tripResults.addErrorListener(error.updateError);
  
  var trip = new com.marklogic.widgets.sparqlbar("query");
  semctx.register(trip);
  trip.refresh(); // shows non-default triple config only if you do this after creation time
  
  
  
  //trip.addErrorListener(error.updateError);
  //trip.addResultsListener(function(res) {tripResults.updateResults(res)});
  
  var info = new com.marklogic.widgets.entityfacts("facts");
  semctx.register(info);
  //info.addErrorListener(error.updateError);
  tripResults.iriHandler(function(iri) {info.updateEntity(iri)});
  info.iriHandler(function(iri){info.updateEntity(iri)});
  //info.setProvenanceWidget(wgt);
  
  var ob = new db.options();
  ob.defaultCollation("http://marklogic.com/collation/en")
    .collectionConstraint() // default constraint name of 'collection' ;
  var options = ob.toJson();
  
  contentctx.setOptions("mljstest-page-search-options",options);
  
  var bar = new com.marklogic.widgets.searchbar("search-bar");
  contentctx.register(bar);
  
    //var wgt = new com.marklogic.widgets.sparqlbar("sparqlbar");
    //wgt.addErrorListener(error.updateError);
  
  } catch (err) {
    error.show(err.message);
    console.log(error);
  }
});