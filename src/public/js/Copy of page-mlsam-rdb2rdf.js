
document.body.onload = function() {
  var db = new mljs();
  db.logger.setLogLevel("debug");
  
  var error = new com.marklogic.widgets.error("errors");
  
  try {
 
    var wgt = new com.marklogic.widgets.rdb2rdf("rdb2rdf");
    document.getElementById("rdb2rdf-mlsam").value = "http://kojak.demo.marklogic.com:8080/mlsam/mlsql";
  
  } catch (err) {
    error.show(err.message);
  }
};
