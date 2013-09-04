
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
    rdfTypeIri: "http://www.ourcompany.com/ontology/JointCustomer", rdfTypeIriShort: "joint:customer", commonNamePredicate: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT",
    properties: [
      {name: "nicclient", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT", shortiri: "nic:client"},
      {name: "nkbcustomer", iri: "http://www.ourcompany.com/ontology/NationalKensingtonBank/CUSTOMER", shortiri: "nkb:customer"}
    ]
  };
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
  var validTriples = [];
  tripleconfig.addMappings("jointcustomer",jointEntity, ?, ?);
  tripleconfig.addMappings("nicclient",nicClientEntity, ?, ?);
  
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
  
    //var wgt = new com.marklogic.widgets.sparqlbar("sparqlbar");
    //wgt.addErrorListener(error.updateError);
  
  } catch (err) {
    error.show(err.message);
  }
});