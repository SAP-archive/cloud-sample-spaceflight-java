# To Swagger transformation

"The OpenAPI Specification, originally known as the Swagger Specification, is
a specification for machine-readable interface files for describing, producing,
consuming, and visualizing RESTful Web services." - [Wikipedia](https://en.wikipedia.org/wiki/OpenAPI_Specification)

In 2015 the Swagger specification was renamed to the OpenAPI specification.
The compiler's functionality provides an output as per the OpenAPI 3.0.0 specification,
regardless of being called 'to Swagger'.

## Transform a CDS model to a swagger json file

Executing the compiler with the `--to-swagger` option or in short `-S` gives the opportunity
based on your CDS model an OpenAPI json file(s) to be produced. In addition to the option, a mandatory
flag(s) needs to be added. The flags can be a comma-separated combination of "json" and "csn".
The `json` flag generate output for each service in the model, the `csn` flag the
preprocessed model with to swagger specifics.

### Basic information

Multiple services generation is supported as for each service in the input CDS model a separate swagger
document is created.

Every OpenAPI 3.0.0 document should have an "openapi" property, which specifies the version of the
specification followed, in our case the "3.0.0" value is assigned. Also, the document receives a property
"info" with "title" and value is the name of the corresponding service for the swagger document.

### Paths

The "paths" property of the OpenAPI document describes the available paths and operations for
the API in question. The unbound actions and functions play a role as a feeder for the
information in the `paths` property of the swagger model.

As the paths property is a mandatory one, if no content for generation is found in the model, then an empty
object will be generated.

#### HTTP method

The corresponding definitions of paths in CDS model are the (un)bound actions and functions.
Such an action or a function must be annotated with the specified annotation so the generator takes
it in mind. The annotation declares the desired HTTP method and the response code.
Three different syntaxes are available:
 1. __@Swagger.GET : 200__ - a GET operation with response code 200 is generated
 2. __@Swagger.POST__ - a POST operation with the default response code is generated
 3. __@Swagger.DELETE : [202, 204, 200]__ - a DELETE operation with responses for every of 202, 204 and 200 codes
 or the three variants can be combined in:
 __@Swagger : { GET : 200, POST, DELETE : [202, 204, 200] }__

> To define a range of response codes, you may use the following range definitions:
> __1XX__, __2XX__, __3XX__, __4XX__, and __5XX__.

By the OpenAPI specification __GET__, __PUT__, __POST__, __DELETE__, __OPTIONS__, __HEAD__, __PATCH__ and __TRACE__
are the supported http verbs. Still not supported in the CDS compiler are only __OPTIONS__ and __TRACE__.

If the user decides not to specify a response code(using the __@Swagger.*method*__), then an operation with default code will be
generated. The default code for a __PATCH__ operation is __204__, for the rest of the operations is __200__.

#### Path to an individual endpoint

If a relative path to an individual endpoint is not specified by the user, then the default one is assigned.
This default path is composed from the service name, the entity name(if the action/function is bound) and the
name of the action. An example for bound action will be:
`/com.test.MyService.MyEntyty/myAction` and for
unbound: `/com.test.MyService/myFunction`.

For the case when the user wants an operation to serves under a specific path, that can be arranged with the __@Swagger.path__
annotation. The custom path can include parameters e.g. ``@Swagger.path : '/MyPath/bookByName/{bookName}'``.
> In this case the user has to take care the names of the parameters to correspond to the name
> of parameters specified in the action/function declaration.

#### Operations parameters

The OpenAPI specification states that a parameter can have location([the property 'in' of a parameter object](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#parameterObject))
with one of the following values:
- query
- header
- path
- cookie

With the __@Swagger.parameter__ annotation applied to a parameter this location can be specified. If not specified - __query__ is taken as value.

> If a value *path* is given for the __@Swagger.parameter__ annotation, this means that automatically the name of the parameter
> is prepended to the path name. This is valid only if a __@Swagger.path__ annotation is not used.

The parameter location resolving is illustrated with the following example:

Given is the CDS model
````
...
actions {
  @Swagger.GET
  action bookById(@Swagger.parameter: 'path' bookId : Integer) returns Book;
  @Swagger.GET
  action bookByName(@Swagger.parameter: 'cookie' bookName: String) returns Book;
  @Swagger.GET
  action booksByAuthor(authorName: String) returns array of Book;
};
...
````

the result will look like:
````json
...
"paths": {
  "/Bookstore/Book/bookById/{bookId}": {
    "get": {
      "summary": "",
      "operationId": "",
      "tags": [],
      "responses": {
        "200": {
          "description": "Expected response to a valid request",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Bookstore.Book"
              }
            }
          }
        },
        "default": {
          "description": "unexpected error",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Error"
              }
            }
          }
        }
      },
      "parameters": [
        {
          "name": "bookId",
          "in": "path",
          "description": "",
          "required": true,
          "schema": {
            "type": "integer",
            "format": "int32"
          }
        }
      ]
    }
  },
  "/Bookstore/Book/bookByName": {
    "get": {
      "summary": "",
      "operationId": "",
      "tags": [],
      "responses": {
        "200": {
          "description": "Expected response to a valid request",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Bookstore.Book"
              }
            }
          }
        },
        "default": {
          "description": "unexpected error",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Error"
              }
            }
          }
        }
      },
      "parameters": [
        {
          "name": "bookName",
          "in": "cookie",
          "description": "",
          "required": false,
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  },
  "/Bookstore/Book/booksByAuthor": {
    "get": {
      "summary": "",
      "operationId": "",
      "tags": [],
      "responses": {
        "200": {
          "description": "Expected response to a valid request",
          "content": {
            "application/json": {
              "schema": {
                "type": "array",
                "items": {
                  "$ref": "#/components/schemas/Bookstore.Book"
                }
              }
            }
          },
          "headers": {
            "x-next": {
              "description": "A link to the next page of responses",
              "schema": {
                "type": "string"
              }
            }
          }
        },
        "default": {
          "description": "unexpected error",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Error"
              }
            }
          }
        }
      },
      "parameters": [
        {
          "name": "authorName",
          "in": "query",
          "description": "",
          "required": false,
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  }
}
...
````

#### Request body

For the __@Swagger.parameter__ annotation can be given one more value - __requestBody__.
This value can be used in a *POST*, *PUT* or *PATCH* requests. It indicates that for the specified parameter
a __requestBody__ property will be generated for the path object.
> Only one parameter can be annotated with this value - the first found will be taken in mind.
> The annotated parameter will *not be included* in the __parameters__ property.

#### Arrayed responses

As seen in the example above, if an action/function has a return type ``... returns array of <entity_name>``, then for the
OpenAPI document the schema for this specific response is of type array with items of type the pointed entity and a header, which
is a link to the next page of responses, or:
````json
"200": {
  "description": "Expected response to a valid request",
  "content": {
    "application/json": {
      "schema": {
        "type": "array",
        "items": {
          "$ref": "#/components/schemas/<entity_name>"
        }
      }
    }
  },
  "headers": {
    "x-next": {
      "description": "A link to the next page of responses",
      "schema": {
        "type": "string"
      }
    }
  }
},
````

### Schemas

One of the major components in an OpenAPI interface file is the components' schemas.
The corresponding artifacts to schemas in the OpenAPI file from a CDS model are the definitions.

Executing the following model:
```
service Petstore {
  entity Pet {
    id : Integer64 not null;
    name : String not null;
    tag : String(10);
  };
};
```
will result in:
```json
...
  "components": {
    "schemas": {
      "Petstore.Pet": {
        "required": [
          "id",
          "name"
        ],
        "properties": {
          "id": {
            "type": "integer",
            "format": "int64"
          },
          "name": {
            "type": "string"
          },
          "tag": {
            "maxLength": 10,
            "type": "string"
          }
        }
      }
...
```

In short, all the artifacts enclosed in a service definition of a CDS model are transformed into a top-level
definitions into the `schemas` part of an OpenAPI json file, except for the services/contexts, unbound actions and functions, namespaces.
A service declaration in a CDS model should be self-containing, which means that is declarations outside of the service are used, an error will
be thrown. The only case that is an exception here is when an element is of a type which is user-defined and the user-defined type is builtin
and outside of the service, then the type of the element is expanded to the builtin type.

When we have an association the target should be from the current service or exposed in the current service via projection.

Every top-level artifact is represented like a Schema Object as described in the [OpenAPI specification](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schemaObject)

The associations are treated regarding their cardinality respectively:
- to-one leads to a single object response with schema as the target
- to-many is represented as an array with items of a type the corresponding target

#### Association redirection in projections

This redirection is expressed in switching the target of an association, which is part of a projection
to the corresponding projection(on the target of the association in the underlying context) from the current service.
For example the following model:

````
service Bookstore {
  entity Book as projection on BookstoreContext.Book;
  entity Author as projection on BookstoreContext.Author;
  @Swagger.GET
  action books() returns array of Book;
};

context BookstoreContext {
  entity Book {
    id : Integer64 not null;
    name : String not null;
    author : association to Author;
  };

  entity Author {
    key id : Integer;
    firstName : String;
    lastName : String;
  };
};
````
will result in:
````json
{
  "openapi": "3.0.0",
  "info": {
    "version": "",
    "title": "Bookstore"
  },
  "paths": {
    "/Bookstore/books": {
      "get": {
        "summary": "",
        "operationId": "",
        "tags": [],
        "responses": {
          "200": {
            "description": "Expected response to a valid request",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Bookstore.Book"
                  }
                }
              }
            },
            "headers": {
              "x-next": {
                "description": "A link to the next page of responses",
                "schema": {
                  "type": "string"
                }
              }
            }
          },
          "default": {
            "description": "unexpected error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Bookstore.Book": {
        "required": [
          "id",
          "name"
        ],
        "properties": {
          "id": {
            "type": "integer",
            "format": "int64"
          },
          "name": {
            "type": "string"
          },
          "author": {
            "$ref": "#/components/schemas/Bookstore.Author"
          }
        }
      },
      "Bookstore.Author": {
        "properties": {
          "id": {
            "type": "integer",
            "format": "int32"
          },
          "firstName": {
            "type": "string"
          },
          "lastName": {
            "type": "string"
          }
        }
      },
      "Error": {
        "required": [
          "code",
          "message"
        ],
        "properties": {
          "code": {
            "type": "integer",
            "format": "int32"
          },
          "message": {
            "type": "string"
          }
        }
      }
    }
  }
}
````
The same redirection is performed for user-defined types, as the type declaration should be also exposed to the service in question.

#### CDS Views

From a view declared in the CDS model is generated a schema similar to the one coming from an entity, as
the logic from the view is not applicable for describe in the API spec.

#### Enums

Declared in the CDS model enums are generated as the values are taken in mind.

````
...
  entity MyEntity {
    elem : String enum { foo = 'bar'; };
  };
...
````
The output:
````json
...
  "components": {
    "schemas": {
      "MyEntity": {
        "properties": {
          "elem": {
            "enum": [
              "bar"
            ],
            "type": "string"
          }
        }
      },
...
````
