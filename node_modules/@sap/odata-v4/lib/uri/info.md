# Components

Table of contents

[How to use the UriParser](#how-to-use-the-uriparser)


## How to use the UriParser

The UriParser takes the edm provider instance and returns an UriInfo object on calling the
`.parse(uri)` method. Each original uri path segment has a corresponding UriResource path segment
after parsing the uri.

```js

const UriParser = require('./lib/uri/UriParser');
const edm = getEdmProviderInstanceSomehow();
const uriParser = new UriParser(edm);


const uriInfo = uriParser.parse(
    "/YourEntitySetName(KeyName=1,Key2Name='2')/YourNavigationProperty/AnyProperty"
);

uriInfo.getPathSegments() // --> [UriResource, UriResource, UriResource]

// First path segment
const first = uriInfo.getPathSegments()[0]; // Returns UriResource
first.getKind() // --> UriResource.ResourceKind.ENTITY
first.getEntitySet() // --> EdmEntitySet
first.getKeyPredicates() // --> [UriParameter, UriParameter]
first.getKeyPredicates()[1].getValue() // --> '2'
first.getKeyPredicates()[1].getEdmRef() // --> Returns the corresponding edm reference object

// Second path segment
const second = uriInfo.getPathSegments()[1]; // Returns UriResource
second.getKind() // --> UriResource.ResourceKind.NAVIGATION_TO_[ONE|MANY]
second.getNavigationProperty() // --> EdmNavigationProperty
second.getTarget() // --> The target of the navigation

// Third path segment
const third = uriInfo.getPathSegments()[2]; // Returns UriResource
third.getKind() // --> UriResource.ResourceKind.[PRIMITIVE|COMPLEX|COMPLEX_COLLECTION|...]_PROPERTY
third.getProperty() // --> EdmProperty

```

## Filter Query Option ##

Accessing the filter query option gets the root node of the filter
expression tree.

## Orderby Query Option ##

Accessing the orderby query option gets an array of orderby-item objects.
Each of these objects can be queried for the root of its expression tree and
for the sorting direction.

## Expand Query Option ##

Accessing the expand query option gets an array of expand-item objects.
Each of these objects can be queried for its path segments, whether all
navigation properties have to be expanded, and for options.

## Select Query Option ##

Accessing the select query option gets an array of select-item objects.
Each of these objects can be queried for its path segments, whether all
properties have been selected, and whether all operations in a schema
namespace have been selected (in this case the namespace also can be
retrieved).

## Search Query Option ##

Accessing the search query option gets the root node of the search expression
tree. Three different kinds of nodes are possible: binary-expression nodes
(where only AND and OR operators can occur), unary-expression nodes (where
only NOT is possible as operator) and literal nodes.

## Expressions ##

### Expression Kinds ###

There are different kinds of expressions. Each kind of expression is
implemented in a separate class with specialized access methods. But all have
a method to get their EDM type.

### Literal Expression ###

A literal expression represents a literal directly written in the expression.

### Alias Expression ###

An alias expression represents a parameter alias. Written as an at-sign
followed by an identifier, it represents a reference to an expression given
as separate query option in the URI. The alias expression has a method to
access this referenced expression.

### Unary Expression ###

A unary expression represents an OData built-in unary operator.
Its operand (an expression) can be accessed as well.

### Binary Expression ###

A binary expression represents an OData built-in binary operator.
Its left and right operands (also expressions) can be accessed as well.

### Method Expression ###

A method expression represents an OData built-in method. Its parameters
(which can in turn be expressions) can be accessed as well.

### Member Expression ###

A member expression represents a path expression to access, in the easiest
case, a member property of the entity the expression refers to. It has a
method to access the URI resource elements the path consists of.

### Type Literal Expression ###

A type-literal expression represents a type name written literally in the
expression, used in the built-in type-related methods. A type cast used in
a path (member expression) does not result in a type-literal expression.
