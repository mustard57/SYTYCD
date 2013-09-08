
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
      {name: "nic_client", iri: "http://www.ourcompany.com/ontology/NewInsuranceCo/CLIENT", shortiri: "nic:client"},
      {name: "nkb_customer", iri: "http://www.ourcompany.com/ontology/NationalKensingtonBank/CUSTOMER", shortiri: "nkb:customer"},
      {name: "jointname", iri: "http://www.ourcompany.com/ontology/JointCustomer/name", shortiri: "joint:name"},
      {name: "jointmentioned_in", iri: "http://marklogic.com/semantics/ontology/mentioned_in"}
    ]
  };
  var jointPredicates = new Array();
  jointPredicates["nic_client"] = {name: "nic_client", title: "Is New Insurance Co Client", iri: "http://www.ourcompany.com/ontology/NewInsuranceCo/CLIENT", shortiri: "nic:client"};
  jointPredicates["nkb_customer"] = {name: "nkb_customer", title: "Is National Kensington Bank Customer", iri: "http://www.ourcompany.com/ontology/NationalKensingtonBank/CUSTOMER", shortiri: "nkb:customer"};
  jointPredicates["jointname"] = {name: "jointname", title: "Has Full Name", iri: "http://www.ourcompany.com/ontology/JointCustomer/name", shortiri: "joint:name"};
  jointPredicates["jointmentioned_in"] = {name: "jointmentioned_in", title: "Mentioned In", iri: "http://marklogic.com/semantics/ontology/mentioned_in"};
  
  var jointTriples = [
    {subjectType: "jointcustomer", objectType: "nicclient", predicateArray: ["nic_client"]},
    {subjectType: "jointcustomer", objectType: "nkbcustomer", predicateArray: ["nkb_customer"]}
  ];
  
  
  var nicClientEntity = {
    name: "nicclient", title: "NIC Client", prefix: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT", iriPattern: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT/CLIENT_ID=#VALUE#",
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT", rdfTypeIriShort: "nic:client", commonNamePredicate: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FAMILY_NAME",
    properties: [
      {name: "clientid", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#CLIENT_ID", shortiri: "nic:client_id", type: "xs:integer"},
      {name: "nicfirstname", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FIRST_NAME", shortiri: "nic:firstname"},
      {name: "nicfamilyname", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FAMILY_NAME", shortiri: "nic:familyname"},
      {name: "nicdob", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#DOB", shortiri: "nic:dob"},
      {name: "profession", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PROFESSION", shortiri: "nic:profession"},
      {name: "m_or_f", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#M_OR_F"},
      {name: "nicemail", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#EMAIL"},
      {name: "nictitle", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#TITLE"},
      {name: "nicaddress_id", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#ADDRESS_ID"},
      {name: "phone_1", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PHONE_1"},
      {name: "phone_2", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PHONE_2"},
      {name: "nicmentioned_in", iri: "http://marklogic.com/semantics/ontology/mentioned_in"}
    ]
  };
  var nicClientPredicates = new Array();
  nicClientPredicates["clientid"] = {name: "clientid", title: "Client ID", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#CLIENT_ID", shortiri: "nic:client_id"};
  nicClientPredicates["nicfirstname"] = {name: "nicfirstname", title: "First Name", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FIRST_NAME", shortiri: "nic:firstname"};
  nicClientPredicates["nicfamilyname"] = {name: "nicfamilyname", title: "Family Name", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#FAMILY_NAME", shortiri: "nic:familyname"};
  nicClientPredicates["nicdob"] = {name: "nicdob", title: "Date of Birth", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#DOB", shortiri: "nic:dob"};
  nicClientPredicates["profession"] = {name: "profession", title: "Profession", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PROFESSION", shortiri: "nic:profession"};
  nicClientPredicates["m_or_f"] = {name: "m_or_f", title: "Male or Female", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#M_OR_F"};
  nicClientPredicates["nicemail"] = {name: "nicemail", title: "Email Address", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#EMAIL"};
  nicClientPredicates["nictitle"] = {name: "nictitle", title: "Title", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#TITLE"};
  nicClientPredicates["nicaddress_id"] = {name: "nicaddress_id", title: "Address ID", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#ADDRESS_ID"};
  nicClientPredicates["phone_1"] = {name: "phone_1", title: "Phone 1", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PHONE_1"};
  nicClientPredicates["phone_2"] = {name: "phone_2", title: "Phone 2", iri: "http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#PHONE_2"};
  nicClientPredicates["nic_address"] = {name: "nic_address", title: "Address", iri:"http://marklogic.com/rdb2rdf/NewInsuranceCo/CLIENT#ref-ADDRESS_ID"};
  nicClientPredicates["nicmentioned_in"] = {name: "nicmentioned_in", title: "Mentioned In", iri: "http://marklogic.com/semantics/ontology/mentioned_in"};
  
  var nicClientTriples = [
    {subjectType: "nicclient", objectType: "nicaddress", predicateArray: ["nic_address"]},
    {subjectType: "nicclient", objectType: "document", predicateArray: ["nicmentioned_in"]}
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
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER", commonNamePredicate: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#SURNAME",
    properties: [
      {name: "customer_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#CUSTOMER_ID", type: "xs:integer"},
      {name: "account_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ACCOUNT_ID", type: "xs:integer"},
      {name: "title", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#TITLE"},
      {name: "first_name", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#FIRST_NAME"},
      {name: "surname", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#SURNAME"},
      {name: "home_phone", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#HOME_PHONE"},
      {name: "mobile_phone", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#MOBILE_PHONE"},
      {name: "date_of_birth", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#DATE_OF_BIRTH"},
      {name: "address_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ADDRESS_ID"},
      {name: "branch_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#BRANCH_ID"},
      {name: "occupation", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#OCCUPATION"},
      {name: "mothers_maiden_name", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#MOTHERS_MAIDEN_NAME"},
      {name: "initial", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#INITIAL"},
      {name: "email", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#EMAIL"},
      {name: "national_insurance_no", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#NATIONAL-INSURANCE-NO"},
      {name: "gender", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#GENDER"},
      {name: "ref-ADDRESS_ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-ADDRESS_ID"},
      {name: "ref-BRANCH_ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-BRANCH_ID"},
      {name: "ref-ACCOUNT_ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-ACCOUNT_ID"}
    ] 
  };
  var nkbCustomerPredicates = new Array();
  nkbCustomerPredicates["customer_id"] = {name: "customer_id", title: "Customer ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#CUSTOMER_ID"};
  nkbCustomerPredicates["account_id"] = {name: "account_id", title: "Account ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ACCOUNT_ID"};
  nkbCustomerPredicates["title"] = {name: "title", title: "Title", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#TITLE"};
  nkbCustomerPredicates["first_name"] = {name: "first_name", title: "First Name", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#FIRST_NAME"};
  nkbCustomerPredicates["surname"] = {name: "surname", title: "Surname", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#SURNAME"};
  nkbCustomerPredicates["home_phone"] = {name: "home_phone", title:"Home Phone Number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#HOME_PHONE"};
  nkbCustomerPredicates["mobile_phone"] = {name: "mobile_phone", title:"Mobile Phone Number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#MOBILE_PHONE"};
  nkbCustomerPredicates["date_of_birth"] = {name: "date_of_birth", title: "Date Of Birth", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#DATE_OF_BIRTH"};
  nkbCustomerPredicates["address_id"] = {name: "address_id", title: "Address ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ADDRESS_ID"};
  nkbCustomerPredicates["branch_id"] = {name: "branch_id", title: "Branch ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#BRANCH_ID"};
  nkbCustomerPredicates["occupation"] = {name: "occupation", title: "Occupation", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#OCCUPATION"};
  nkbCustomerPredicates["mothers_maiden_name"] = {name: "mothers_maiden_name", title: "Mothers Maiden Name", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#MOTHERS_MAIDEN_NAME"};
  nkbCustomerPredicates["initial"] = {name: "initial", title: "Initial", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#INITIAL"};
  nkbCustomerPredicates["email"] = {name: "email", title: "Email Address", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#EMAIL"};
  nkbCustomerPredicates["national_insurance_no"] = {name: "national_insurance_no", title: "National Insurance Number",iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#NATIONAL-INSURANCE-NO"};
  nkbCustomerPredicates["gender"] = {name: "gender", title: "Gender", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#GENDER"};
  nkbCustomerPredicates["ref-ADDRESS_ID"] = {name: "ref-ADDRESS_ID", title: "Address", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-ADDRESS_ID"};
  nkbCustomerPredicates["ref-BRANCH_ID"] = {name: "ref-BRANCH_ID", title: "Branch", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-BRANCH_ID"};
  nkbCustomerPredicates["has_nkb_account"] = {name: "has_nkb_account", title: "Account", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/CUSTOMER#ref-ACCOUNT_ID"};
  var nkbCustomerTriples = [
    {subjectType: "nkbcustomer", objectType: "nkbaccount", predicateArray: ["has_nkb_account"]}
  ];
  
  var nkbAccountEntity = {
    name: "nkbaccount", title: "NKB Account", prefix: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT", iriPattern: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT/ACCOUNT_ID=#VALUE#",
    rdfTypeIri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT", commonNamePredicate: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-NUMBER",
    properties: [
      {name: "nkbaccount_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT_ID"},
      {name: "nkbaccount-number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-NUMBER"},
      {name: "nkbsort-code", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#SORT-CODE"},
      {name: "nkbaccount-status_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-STATUS_ID"},
      {name: "nkbaccount-type_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-TYPE_ID"},
      {name: "nkbcustomer_id", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#CUSTOMER_ID"},
      {name: "nkbbalance", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#BALANCE", type: "xs:double"}
    ] 
  };
  var nkbAccountPredicates = new Array();
  nkbAccountPredicates["nkbaccount-number"] = {name: "nkbaccount-number", title: "Account Number", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-NUMBER"};
  nkbAccountPredicates["nkbbalance"] = {name: "nkbbalance", title: "Balance", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#BALANCE"};
  nkbAccountPredicates["nkbaccount_id"] = {name: "nkbaccount_id", title: "Account ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT_ID"};
  nkbAccountPredicates["nkbsort-code"] = {name: "nkbsort-code", title: "Sort Code", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#SORT-CODE"};
  nkbAccountPredicates["nkbaccount-status_id"] = {name: "nkbaccount-status_id", title: "Account Status ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-STATUS_ID"};
  nkbAccountPredicates["nkbaccount-type_id"] = {name: "nkbaccount-type_id", title: "Account Type ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#ACCOUNT-TYPE_ID"};
  nkbAccountPredicates["nkbcustomer_id"] = {name: "nkbcustomer_id", title: "Customer ID", iri: "http://marklogic.com/rdb2rdf/NationalKensingtonBank/ACCOUNT#CUSTOMER_ID"};
  var nkbAccountTriples = [
  ];
  
  db.logger.debug("ENTITY: " + JSON.stringify(jointEntity));
  db.logger.debug("PREDICATES: " + JSON.stringify(jointPredicates));
  db.logger.debug("TRIPLES: " + JSON.stringify(jointTriples));
  
  
  var docEntity = {
    name: "document", title: "MarkLogic Document", prefix: "/docs/", iriPattern: "/docs/#VALUE#",
    rdfTypeIri: "http://marklogic.com/semantics/ontology/Document", commonNamePredicate: "http://marklogic.com/semantics/ontology/Document",
    properties: [
      {name: "docuri", iri: "http://marklogic.com/semantics/ontology/Document"}
    ] 
  };
  var docPredicates = new Array();
  docPredicates["docuri"] = {name: "docuri", title: "Document", iri: "http://marklogic.com/semantics/ontology/Document"};
  var docTriples = [];
  
  tripleconfig.addMappings("jointcustomer",jointEntity, jointPredicates, jointTriples);
  tripleconfig.addMappings("nicclient",nicClientEntity, nicClientPredicates, nicClientTriples);
  tripleconfig.addMappings("nicaddress",nicAddressEntity, nicAddressPredicates, nicAddressTriples);
  tripleconfig.addMappings("nkbcustomer",nkbCustomerEntity, nkbCustomerPredicates, nkbCustomerTriples);
  tripleconfig.addMappings("nkbaccount",nkbAccountEntity, nkbAccountPredicates, nkbAccountTriples);
  tripleconfig.addMappings("document",docEntity, docPredicates, docTriples);
  
  var semctx = new db.semanticcontext();
  semctx.setConfiguration(tripleconfig);
  semctx.setContentMode("contribute");
  var contentctx = new db.searchcontext();
  semctx.setContentContext(contentctx);
 
  var wgt = new com.marklogic.widgets.searchresults("search-content");
  contentctx.register(wgt);
  //wgt.addErrorListener(error.updateError);
  //wgt.bar.setTransform("redaction");
  //wgt.bar.setFormat("xml"); // redaction transform will convert to JSON
  
  var tripResults = new com.marklogic.widgets.sparqlresults("triple-content");
  semctx.register(tripResults);
  tripResults.setProvenanceSparqlMentioned();
  //tripResults.addErrorListener(error.updateError);
  
  var trip = new com.marklogic.widgets.sparqlbar("query");
  semctx.register(trip);
  trip.setLang(undefined);
  trip.refresh(); // shows non-default triple config only if you do this after creation time
  
  
  
  //trip.addErrorListener(error.updateError);
  //trip.addResultsListener(function(res) {tripResults.updateResults(res)});
  
  var info = new com.marklogic.widgets.entityfacts("facts");
  semctx.register(info);
  info.setProvenanceSparqlMentioned();
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
  bar.setModeContributeStructured();
  
    //var wgt = new com.marklogic.widgets.sparqlbar("sparqlbar");
    //wgt.addErrorListener(error.updateError);
    
  var kratu = new com.marklogic.widgets.kratu("kratu");
  var listSemanticContext = new db.semanticcontext();
  listSemanticContext.register(kratu);
  
  var docsemlink = new com.marklogic.widgets.docsemlink("docsemlink");
  contentctx.register(docsemlink);
  listSemanticContext.register(docsemlink);
  docsemlink.setKratu("kratu");
  
  } catch (err) {
    error.show(err.message);
    console.log(error);
  }
});