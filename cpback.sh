#!/bin/sh
cp -f src/public/js/widget-rdb2rdf.js ../mljs/mldbwebtest/src/public/js/mldbtest/
cp -f src/public/js/widget-triples.js ../mljs/mldbwebtest/src/public/js/mldbtest/
cp -f src/public/js/widget-search.js ../mljs/mldbwebtest/src/public/js/mldbtest/
cp -f src/public/css/widgets.css ../mljs/mldbwebtest/src/public/js/mldbtest/
cp -f src/public/js/mljs.js ../mljs/mldbwebtest/src/public/js/mldbtest/
cp -f src/public/js/mljs.js ../mljs/
echo "Copied sparql code back to MLJS"
exit 0

