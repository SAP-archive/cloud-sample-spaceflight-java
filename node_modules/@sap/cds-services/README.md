# CDS Services #

This package handles the generation of an OData service using the provided model. It is possible to start N services per server and each service has its own endpoint. This package also offers the possibility to register custom handlers for performing create, read, update and delete operations.

## Overview ##
TBD

## Prerequisites ##
Dependencies:
* @sap/cds-ql
* @sap/odata-v4

## Installation ##
~~~~
npm install
~~~~

## Usage/Configuration ##
### Examples ###
Following is an example of the service factory, which will create an OData Service:
~~~~
const serviceInstance = cds.service('cat-service', {}, function() {
  this.use((req,res,next)=>{/* ... */})
})
serviceInstance.use ((req,res,next)=>{/* ... */})
~~~~

### OData Requests Supported by Generic Handlers ###
| Request| Description |
|-----|-----|
| POST /Employees |	create entity; if UUID key exists, UUID is generated if it is not provided |
| PUT /Employees(4) |	update entity; Complete or subset of properties, 404 if entity cannot be found |
| DELETE /Employees(4) |	delete entity; 404 if entity cannot be found|
| GET /Employees	| read collection|
| GET /Employees/$count |	get the number of elements in a collection |
| GET /Employees(4)	 |	read entity; 404 if entity cannot be found |
| GET /Authors(4)/name	 |	read property of entity |
| GET /Citations(source=1,target=3)	 |	read entity with multiple key elements |
| GET /Employees?$filter=birthyear eq 1980	 |	filter collection |
| GET /Employees/$count?$filter=birthyear eq 1980	 |	count the number of elements in a collection after applying the filter |
| GET /Employees?$orderby=birthyear desc,name asc |		order collection |
| GET /Employees?$top=1	 |	read first N records of collection |
| GET /Employees?$top=1&$skip=2	 |	read first N records of collection after skipping M records |
| GET /Employees?$skip=2	 |	read collection after skipping N records |
| GET /Employees?$select=id,birthyear	 |	read subset of properties per entity |
| GET /Employees?$count=true |	read collection and include the number of elements in the result set (can be combined with to-many-associations, $top, $skip, $orderby and $filter. Note that $filter will be reflected in the number of elements) |
| GET /Books(3)/author |	navigation via managed or unmanaged to-one association |
| GET /Books(3)/orders |	navigation via managed to-many association (with or w/o $self) |
| GET /Books(3)/orders(6a48328d-55f8-4c0a-8974-433ca4421b26)/book/author/name |	navigation with multiple path segments |
| GET /Employees?odata-debug=json |	Show debug output in json format if enabled (configurable parameter 'debug: true' when service is created) |
| GET /Employees?odata-debug=html |	Show debug output in html format if enabled (configurable parameter 'debug: true' when service is created)|

## Reference ##
TBD
