xquery version "1.0-ml";

module namespace c = "http://marklogic.com/roxy/controller/charts";

(: the controller helper library provides methods to control which view and template get rendered :)
import module namespace ch = "http://marklogic.com/roxy/controller-helper" at "/roxy/lib/controller-helper.xqy";

import module namespace config = "http://marklogic.com/roxy/config" at "/app/config/config.xqy";

(: The request library provides awesome helper methods to abstract get-request-field :)
import module namespace req = "http://marklogic.com/roxy/request" at "/roxy/lib/request.xqy";

import module namespace s = "http://marklogic.com/roxy/models/search" at "/app/models/search-lib.xqy";

declare option xdmp:mapping "false";

(:
 : Usage Notes:
 :
 : use the ch library to pass variables to the view
 :
 : use the request (req) library to get access to request parameters easily
 :
 :)
declare function c:main() as item()*
{
	let $q := req:get("q", "", "type=xs:string")
	let $facet-name := req:required("facet")
	let $facet := s:facets-only($q, $config:SEARCH-OPTIONS)[@name = $facet-name]
	return
	(
		ch:add-value("facet", $facet),
		ch:use-view((), "xml"),
		ch:use-layout(())
	)
};
