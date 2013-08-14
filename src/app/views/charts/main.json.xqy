xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

import module namespace json = "http://marklogic.com/json" at "/roxy/lib/json.xqy";

declare namespace search = "http://marklogic.com/appservices/search";

declare option xdmp:mapping "false";

declare variable $facet := vh:get("facet");

json:serialize(
  json:o(("series",
    if ($facet) then
      json:a((
        for $value in $facet/search:facet-value
        return
          json:o((
            "name", fn:string($value/@name),
            "y", xs:int($value/@count)
          ))
      ))
    else
      json:null()
  ))
)