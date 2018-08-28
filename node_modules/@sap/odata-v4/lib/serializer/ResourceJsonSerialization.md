# Serializing OData resources to JSON format

In order to serialize an OData resource such as entity or entity collection
to OData JSON format, ResourceJsonSerializer class should be used.
The class has a number of methods taking an OData resource as an input and
returning the serialized resource as a JSON string.

## Serializing entity

In order to serialize an entity to OData JSON format, serializeEntity method
should be called on an instance of ResourceJsonSerializer class. 

The method takes EDM entity type, entity data and control information as
the input. The entity type of the entity must be  specified as an instance
of EdmEntityType class. The entity data must be specified as a plain JSON
object with property-value pairs corresponding to the EDM properties of the
entity type. Values for the entity properties must be formatted according to
the types of the corresponding EDM properties. 

### Serializing entity with primitive properties

The table below describes the formatting and mapping rules between the EDM
primitive types and JavaScript / Node.js types.

EDM type | JS / Node.js type | Value format
-------- | ----------------- | ------------
Edm.Binary | Buffer |
Edm.Boolean | boolean | 
Edm.Byte | number | integer number value in the range from 0 to 255
Edm.SByte | number | integer number value in the range from -128 to 127
Edm.Int16 | number | integer number in the range from -32768 to 32767
Edm.Int32 | number | integer number in the range from -2147483648 to 2147483647
Edm.Int64 | number or string | integer number in the range from -9223372036854775808 to 9223372036854775807. In case the value is too big to be correctly represented as an integer number in JavaScript, it should be specified as a string. The value can be in either decimal or in an exponential notation.
Edm.Date | string | YYYY-MM-DD
Edm.DateTimeOffset | string | YYYY-MM-DDThh:mm:ss.sTZD
Edm.TimeOfDay | string | hh:mm:ss.s
Edm.Duration | string | PnDTnHnMn.nS
Edm.Decimal | number or string | number value represented as a JavaScript number or a string, in case the value is too big to be correctly represented as a number in JavaScript. The value can be in either decimal or in an exponential notation.
Edm.Single | number | number with the absolute value in the range from 1.401298464324817E-45 to 3.4028234663852886E+38
Edm.Double | number | 
Edm.Guid | string | 8HEXDIG-4HEXDIG-4HEXDIG-4HEXDIG-12HEXDIG
Edm.String | string | 

Only the aforementioned primitive types are supported. More information
about the format of the property values can be found in the ABNF
Construction Rules document for the OData specification.

Example:
```javascript
const edmEntityType = someEntityTypeValue;

const entity = {
    '*@odata.context': '$metadata#SomeEntitySet/$entity',
    value: {
        PropertyInt16: 32767,
        PropertyString: 'First Resource - positive values',
        PropertyBoolean: true,
        PropertyByte: 255,
        PropertySByte: 127,
        PropertyInt32: 2147483647,
        PropertyInt64: 9007199254740991,
        PropertySingle: 1.79E+20,
        PropertyDouble: -1.79E+19,
        PropertyDecimal: 34,
        PropertyBinary: Buffer.from('ASNFZ4mrze8=', 'base64'),
        PropertyDate: '2012-12-03',
        PropertyDateTimeOffset: '2012-12-03T07:16:23Z',
        PropertyDuration: 'P0DT0H0M6S',
        PropertyGuid: '01234567-89ab-cdef-0123-456789abcdef',
        PropertyTimeOfDay: '03:26:05'
    }
};

const resourceSerializer = new ResourceJsonSerializer();
const serializedEntity = resourceSerializer.serializeEntity(edmEntityType, entity);
```
The serialized entity:
```javascript
{	
	'@odata.context': "$metadata#SomeEntitySet/$entity" ,
	PropertyInt16: 32767,
	PropertyString: "First Resource - positive values",
	PropertyBoolean: true,
	PropertyByte: 255,
	PropertySByte: 127,
	PropertyInt32: 2147483647,
	PropertyInt64: 9007199254740991,
	PropertySingle: 179000000000000000000,
	PropertyDouble: -17900000000000000000,
	PropertyDecimal: 34,
	PropertyBinary: "ASNFZ4mrze8=",
	PropertyDate: "2012-12-03",
	PropertyDateTimeOffset: "2012-12-03T07:16:23Z",
	PropertyDuration: "P0DT0H0M6S",
	PropertyGuid: "01234567-89ab-cdef-0123-456789abcdef",
	PropertyTimeOfDay: "03:26:05"
}
```

Very big values for Edm.Int64 or Edm.Decimal properties of the entity can
not be represented as numbers in JavaScript. They have to be passed to the
serializer as strings. If the ResourceJsonSerializer is created with a
constructor parameter requesting IEEE754-compatible output, Edm.Int64 and
Edm.Decimal values are serialized as strings. If standard output is
requested and numbers are not representable as Javascript numbers, an error
is thrown.

Decimal numbers are serialized in exponential notation if requested with the
constructor parameter. This works only if decimal numbers are serialized as
strings.

Example:
```javascript
const edmEntityType = someEntityTypeValue;

const entity = {
    '*@odata.context': '$metadata#SomeEntitySet/$entity',
    value: {
        PropertyInt16: 32767,
        PropertyString: 'First Resource - positive values',
        PropertyBoolean: true,
        PropertyByte: 255,
        PropertySByte: 127,
        PropertyInt32: 2147483647,
        PropertyInt64: '9223372036854775807',   // too big integer value to be correctly represented in JavaScript
        PropertySingle: 1.79E+20,
        PropertyDouble: -1.79E+19,
        PropertyDecimal: 34,
        PropertyBinary: Buffer.from('ASNFZ4mrze8=', 'base64'),
        PropertyDate: '2012-12-03',
        PropertyDateTimeOffset: '2012-12-03T07:16:23Z',
        PropertyDuration: 'P0DT0H0M6S',
        PropertyGuid: '01234567-89ab-cdef-0123-456789abcdef',
        PropertyTimeOfDay: '03:26:05'
    }
};

const resourceSerializer = new ResourceJsonSerializer(
    new JsonContentTypeInfo()
        .addParameter(JsonContentTypeInfo.FormatParameter.IEEE754, 'true')
        .addParameter(JsonContentTypeInfo.FormatParameter.EXPONENTIAL_DECIMALS, 'true'));
const serializedEntity = resourceSerializer.serializeEntity(edmEntityType, entity);
```
The serialized entity:
```javascript
{	
  @odata.context: "$metadata#SomeEntitySet/$entity" 
  PropertyInt16: 32767,
  PropertyString: 'First Resource - positive values',
  PropertyBoolean: true,
  PropertyByte: 255,
  PropertySByte: 127,
  PropertyInt32: 2147483647,
  PropertyInt64: '9223372036854775807',
  PropertySingle: 179000000000000000000,
  PropertyDouble: -17900000000000000000,
  PropertyDecimal: '3.4e+1',
  PropertyBinary: 'ASNFZ4mrze8=',
  PropertyDate: '2012-12-03',
  PropertyDateTimeOffset: '2012-12-03T07:16:23Z',
  PropertyDuration: 'P0DT0H0M6S',
  PropertyGuid: '01234567-89ab-cdef-0123-456789abcdef',
  PropertyTimeOfDay: '03:26:05'
}
```

### Serializing entity with complex properties

In case an entity with a complex property has to be serialized, the property
value must be represented as an object with the property-value pairs
according to the properties of the corresponding EDM ComplexType.

Example:
```javascript
const entity = {
    value: {
        PropertyInt16: 7,
            ComplexProperty: {
            PropertyString: 'Second Resource - second',
            PropertyBoolean: true,
            PropertyByte: 255
        }
    }
};
```
The serialized entity:
```javascript
{	
  @odata.context: "$metadata#SomeEntitySet/$entity" 
  PropertyInt16: 7,
  ComplexProperty: {
  	PropertyString: "Second Resource - second",
	PropertyBoolean: true,
	PropertyByte: 255
  }
}
```

### Serializing entity with collection properties

In case an entity with a collection property has to be serialized, the
property value must be represented as an array. For primitive collection
properties, the array must contain primitive values, formatted according
to the primitive property type. For complex collection properties, the array
must contain objects, where each of the objects corresponds to the structure
of the EDM ComplexType, which is specified for the property.

### Serializing entity with selected properties using $select

$select may act on primitive, complex, and collection properties, whose
values must conform the defined rules in the previous sections. Furthermore,
$select may also act on navigation properties, which are unnecessary to be
present in the data.

Note that selecting a property that belongs to the EDM properties of the
entity type but is not present in the data causes the property to be
serialized with a value of:

* "null", for primitive and complex properties, or
* an empty array [ ], for collection properties.

### Serializing entity with expanded navigation properties using $expand

$expand acts on navigation properties to-one and to-many.

* Expand to-one navigation property:
The value of the navigation property should be given as a plain JSON object
with property-value pairs corresponding to the EDM properties of the target
entity type. Serializing this JSON object is subject to the same defined
rules in the previous sections.
Example:
```javascript
const entity = {
    value: {
        PropertyInt16: 1,
        NavPropertyToOne: {
            PropertyString: 'abc',
            PropertyBoolean: true
        }
    }
};
```

If the navigation property was not present in the data, it is serialized
with a "null" value.

* Expand to-many navigation property:
The value of the navigation property must be specified as an array of JSON
objects with the same defined rules in the previous sections.
Example:
```javascript
const entity = {
    value: {
        PropertyInt16: 2,
        NavPropertyToMany: [
            {
                PropertyString: 'abc',
                PropertyBoolean: true
            },
            {
                PropertyString: 'def',
                PropertyBoolean: false
            }
        ]
    }
};
```

If the navigation property was not present in the data, it is serialized
with an empty array [ ].

## Serializing entity collection

In order to serialize an entity collection to OData JSON format,
serializeEntityCollection method should be called on an instance of
ResourceJsonSerializer class. 

The method takes EDM entity type, entity collection data and control
information for the entity collection as the input. The entity type of the
entities in the entity collection must be specified as an instance of
EdmEntityType class. The entity collection data must be specified as an
array of JSON objects with the same structure as the one described in
the 'Serializing entity' section.

Example:
```javascript
const entities = {
    '*@odata.context': '$metadata#SomeEntitySet',
    '*@odata.count': 3,
    value:[
        {
            PropertyInt16: 1,
            PropertyString: 'Test String1'
        },
        {
            PropertyInt16: 2,
            PropertyString: 'Test String2'
        },
        {
            PropertyInt16: 3,
            PropertyString: 'Test String3'
        }
    ]
};

const entityType = someEntityType;

const resourceSerializer = new ResourceJsonSerializer();

const serializedEntityCollection =
    resourceSerializer.serializeEntityCollection(entityType, entities);
```

The serialized entity collection:
```javascript
{
    "@odata.context": "$metadata#SomeEntitySet",
    "@odata.count": 3,
    "value": [
        {
            "PropertyInt16": 1,
            "PropertyString": "Test String1"
        },
        {
            "PropertyInt16": 2,
            "PropertyString": "Test String2"
        },
        {
            "PropertyInt16": 3,
            "PropertyString": "Test String3"
        }
    ]
}
```

## Serializing primitive property or primitive-type value

In order to serialize a primitive-type property of an entity or a single
primitive-type value in OData JSON format, the `serializePrimitive` method
should be called on an instance of the `ResourceJsonSerializer` class.

The method takes the primitive EDM type or the EDM property, the value,
and control information as the input. The value must be specified as a plain
JSON object corresponding to the EDM type (of the property, if applicable).

Example:
```javascript
const edmType = EdmPrimitiveTypeKind.Boolean;
const value = {
    '*@odata.context': '$metadata#Edm.Boolean',
    value: true
};

const resourceSerializer = new ResourceJsonSerializer();
const serialized = resourceSerializer.serializePrimitive(edmType, value);
```
The serialized primitive value:
```JSON
{
  "@odata.context": "$metadata#Edm.Boolean",
  "value": true
}
```

## Serializing complex property or complex-type value

In order to serialize a complex-type property of an entity or a single
complex-type value in OData JSON format, the `serializeComplex` method
should be called on an instance of the ResourceJsonSerializer class.

The input is as described above, except that the value now must be a
Javascript object with property-value pairs according to the properties
of the corresponding EDM complex type.

Furthermore, it is possible to pass an array of `SelectItem`s and an array
of `ExpandItem`s as described above for entities.

Example:
```javascript
const data = {
    '*@odata.context': '$metadata#Namespace1_Alias.CTTwoPrim',
    value:{ PropertyInt16: 1, PropertyString: '2' }
};

const resourceSerializer = new ResourceJsonSerializer();
const serialized = resourceSerializer.serializeComplex(edmType, data);
```
The serialized complex value:
```JSON
{
  "@odata.context": "$metadata#Namespace1_Alias.CTTwoPrim",
  "PropertyInt16": 1,
  "PropertyString": "2"
}
```

## Serializing collection property or typed value collection

In order to serialize a (primitive or complex) collection property of an
entity or a collection of (primitive or complex) typed values in OData JSON
format, the `serializePrimitiveCollection` or the
`serializeComplexCollection` method, respectively, should be called on an
instance of the ResourceJsonSerializer class.

The input is as described above, except that the value now must be an array.

Example:
```javascript
const edmType = EdmPrimitiveTypeKind.Boolean;
const data = {
    '*@odata.context': '$metadata#Collection(Edm.Boolean)',
    value: [true, false, null]
};

const resourceSerializer = new ResourceJsonSerializer();
const serialized = resourceSerializer.serializePrimitiveCollection(edmType, data);
```
The serialized collection:
```JSON
{
  "@odata.context": "$metadata#Collection(Edm.Boolean)",
  "value": [true, false, null]
}
```
