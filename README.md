SYTYCD
======

This repository holds the submission to So You Think You Can Demo for team KoJAk = Ken Tune, Jochen Joerg and Adam Fowler.

## Scenario

A Bank has just bought an Insurance Company. They want to repidly find how to save money. To answer the question of who their
most expensive customers are they need to combine data in to Relational Databases - one from each company, each with different schema, 
and information embedded within Insurance Claims documents. Using MarkLogic 7's document database and triple store they find they
can easily find this answer in just a few minutes.

## Elevator pitch

TODO by Adam Fowler on Mon 9th Sep...

## Demo video

This (very cheesy video) can be watched on YouTube at: http://youtu.be/4cUqMzsu0F4

Demo is near real time. I had to get it to 5 minutes in length, so have trimmed some of the browser lag time, and typing time. You can see
the whole demonstration from start to finish though, with background information.

## Demo Script

This is located in the repository in Word format at: https://github.com/mustard57/SYTYCD/blob/master/presentation/KojakDemoScript-AF.docx 

## Sales Background

There are many prospects that have a requirement for relational data migration and adhoc business user querying. Sparql and MarkLogic
content search are a good fit for this requirement. This demonstration shows how you can quickly get answers by using an Enterprise NoSQL
database. For a list of customers and total $ amount please contact Adam Fowler.

## Data and software statement

No third party data or paid for software was used in the demonstration.

## Re-usability

The vast majority of this demonstration can be re-used. The MLJS MarkLogic REST API toolkit and widgets were used to build the UI. MLSAM
was used for integration to a relational database (MySQL). Below is a complete list of what is reusable:-

- MLJS Widgets - many exist, those shown include the rdb2rdf import wizard, sparql search bar, sparql results, entity facts, content search bar, content search results, and google Kratu (table data visualisation)
- Roxy was used as a web framework in hybrid mode so we could connect MLJS to the V7 REST API
- RDB2RDF Rest Extension for importing relational DB tables in to the triple store
- QConsole inferencing sample scripts and test search are available in a workspace in this GitHub repository
- Ken Tune created a database generation script to generate unique and related data for the two different database schemas. This will be very useful for future demonstrations where we are not permitted access to customer data.

The only code not completely re-usable was the JavaScript to configure how the widgets were initialised on the screen, and which entities and relationships were shown (as they are ontology specific), and the docsemlink widget which extracted the document URIs from the final matching doc list (created through using a combined semantic and content search) and generating SPARQL to fetch summary information on customers for use by the 'CEO'. In total only 370 lines of code are not reusable. 12130 lines of code are re-usable. [1]

This means only 2.96 % of the code is NOT re-usable. Happy days.

[1] Total combines the sql.xqy, rdb2rdf.xqy, rdb2rdf-lib.xqy, mljs.js, widgets.js, widgets.css, widget-triples.js, widget-kratu.js, widget-search.js, widget-rdb2rdf.js. This excludes their underlying dependencies.

Note that MLJS is fully documented on GitHub.

## Extending this demonstration

In the future potential avenues of extension include:-

- HighCharts or network node widgets over triple search results
- Include a larger sample of documents linked to customers
- Add a query that is mainly a content query, but with some aspects of triples (we did the opposite, concentrating on the triples but including basic document search. As we're all familiar with content search this seemed logical)
- Adding a cross selling example rather than only cost reduction
- Add support for generating an ontology description automatically to the rdb2rdf rest extension as an output of the import operation
- Amalgamate data from document range indexes, sparql result triples, and live data from an external RDBMS (i.e. no import needed) in to a combined customer view information page
- Extend the data generation script to include sample document generation

## Open Standards

In addition to the usual MarkLogic open standards, this demo made use of Sparql, REST, The W3C's RDB2RDF direct mapping for converting relational schema to triples, ANSI SQL and the Information Schema standards for accessing SQL table structure and relationship information.

## Open Source software used

960.css and bootstrap.css were used to control the layout. Roxy was used as the configuration and deployment mechanism for MarkLogic. Google Kratu was used as a tabular visualisation of triple data (sparql results). MLJS was used for abstracting the REST calls and to provide visualisation widgets. This is licensed, like Roxy, under the Apache 2 license. MySQL was used as the relational database. Tomcat was used to host the MLSAM instance for database communication. MLSAM's sql.xqy extension was used to communicate to MLSAM. ECMAScript 3 (JavaScript) and CSS 2 and 3 were used for the UI.

No proprietary software or platform specific hacks were used for this demonstration, maximising re-usability.