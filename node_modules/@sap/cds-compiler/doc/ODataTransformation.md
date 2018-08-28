# ODATA Transformation

Prior to the generation of EDMX (Entity Data Model XML) files from a CDS model,
the following transformations are applied to the model. Most (but not all) of
them become visible both in Augmented CSN and in Plain CSN:

## Generated foreign key fields for managed associations

Managed associations do not have ON-conditions. Instead, they implicitly
compare fields (usually the key fields) of the association's target entity with
foreign key fields automatically generated into the entity containing the
association.

### Creating the generated fields

The ODATA transformation adds the generated foreign key fields to the model.
The names of the generated foreign key fields are a concatenation of the
association element name, an underscore, and the key name or its alias.

Each generated foreign key field gets the name of the corresponding association
as an annotation `@odata.foreignKey4`.

_FIXME_: Do we want to keep that?

For example, for the three association elements `a1`, `a2` and `a3` in the
following snippet:

```
service S {
  entity FromEntity {
    a1 : association to ToEntity;          // Use target's keys
    a2 : association to ToEntity {x};      // Explicitly specified key
    a3 : association to ToEntity {x as z}; // Key with alias
  }

  entity ToEntity {
    key x : Integer;
    key y : Integer;
  }
}
```

the ODATA transformation would generate foreign key fields in the resulting CSN
as follows (shown here in CDS source form):

```
entity FromEntity {
  a1 : association to ToEntity;
  a2 : association to ToEntity {x};
  @odata.foreignKey4: 'a1'
  a1_x : Integer;  // Generated foreign key
  @odata.foreignKey4: 'a1'
  a1_y : Integer;  // Generated foreign key
  @odata.foreignKey4: 'a2'
  a2_x : Integer;  // Generated foreign key
  @odata.foreignKey4: 'a3'
  a3_z : Integer;  // Generated foreign key
}
```

It is an error if the generated fields conflict with existing fields.

### Annotation propagation

The ODATA transformation propagates all annotations from the association to all
its generated foreign key fields.

_FIXME_: Do we want to keep that?

### Connecting the associations with the generated fields

The CSN for the managed association elements contains a `foreignKeys` property,
which is a dictionary of foreign key names (taken from the target key names, or
from explicitly specified keys resp. their aliases) to the foreign key
properties.

The ODATA transformation adds a `generatedFieldName` property to each foreign
key, containing the name of the generated foreign key field. Together with the
`@odata.foreignKey4` annotation described above, this provides a bi-directional
link between the association and its generated field.

For the example shown above, the CSN for the three association elements `a1`,
`a2` and `a3` would look as follows:

```
  "a1": {
    "indexNo": 1,
    "target": "S.ToEntity",
    "type": "cds.Association",
    "foreignKeys": {
      "x": {
        "indexNo": 1,
        "path": "x",
        "generatedFieldName": "a1_x"
      },
      "y": {
        "indexNo": 2,
        "path": "y",
        "generatedFieldName": "a1_y"
      }
    }
  },
  "a2": {
    "indexNo": 2,
    "target": "S.ToEntity",
    "type": "cds.Association",
    "foreignKeys": {
      "x": {
        "path": "x",
        "indexNo": 1,
        "generatedFieldName": "a2_x"
      }
    }
  },
  "a3": {
    "indexNo": 3,
    "target": "S.ToEntity",
    "type": "cds.Association",
    "foreignKeys": {
      "z": {
        "path": "x",
        "indexNo": 1,
        "generatedFieldName": "a3_z"
      }
    }
  },
```

## (Augmented CSN only): Adding `_service` to exposed artifacts

For each artifact that is exposed by a service (including the service itself),
the ODATA transformation adds a non-enumerable property `_service` to the
artifact in the Augmented CSN model, containing a link to the corresponding
service artifact.

This is convenient for EDMX processors that want to process only exposed
artifacts or only artifacts belonging to a specific service.

## Implicit redirection for non-exposed association targets

For each exposed artifact that contains associations, it is checked that the
association target is also exposed by the same service. If this is not the
case, the ODATA transformation tries to find an "exposed representative" of
the target, i.e. an exposed projection or view on the target, or an exposed entity
that includes the target. If such a representative is found and unique, the
association is implicitly redirected to the exposed representative.

Note that only projections and projection-like views (i.e. those that have a
single `from` source without `union`, `join` or nested queries) are considered
as implicit redirection targets.

Example:

```
// All these entities are used as association targets below
// Simple target
entity E1 {
  key id : Integer;
}
// Base target included by E2a
entity E2 {
  key id : Integer;
}
entity E2a : E2 {
  s : String(10);
}
// Base target included by S.E3a
entity E3 {
  key id : Integer;
}

// Exposure in service
service S {
  entity P1 as projection on E1;    // Exposes simple target E1
  entity P2a as projection on E2a;  // Exposes E2a but also its included E2
  entity E3a : E3 { };              // Exposes included E3

  entity Redirected {
    toE1 : association to E1;   // Implicitly redirected to P1 (projection exposes E1)
    toE2 : association to E2;   // Implicitly redirected to P2a (projection exposes something that includes E2)
    toE3 : association to E3;   // Implicitly redirected to E3a (entity includes E3)
  }
}
```

## Exposure checking

Currently, it is assumed that services must be self-contained, i.e. that all
associations within a service must point to targets also exposed by this
service. This is checked by the ODATA transformation.

_FIXME: The same restriction will probably apply when structured types are
allowed as element types within exposed entities._

## Unraveling derived scalar types

The ODATA transformation unravels derived scalar types, i.e. primitive types
for which the user has provided a custom name (possibly multiple times in a
chain) are replaced by the original primitive type. Annotations are propagated
upwards in the chain from the primitive type to the most derived type.

For example, the following CDS source

```
@IsName: true
type Name : String(20);

@IsCustomer: true
type CustomerName : Name;

service S {
  entity E {
    name : CustomerName;
  }
}
```

essentially behaves as if the user had written

```
service S {
  entity E {
    @IsCustomer: true
    @IsName: true
    name : String(20);
  }
}
```

## (Tentative): Checking ON-conditions

Currently, the ODATA transformation checks for various restrictions regarding
ON-conditions of unmanaged associations:

- only `=` and `AND` operators may be used
- operands may only be paths or values (not expressions)
- exactly one of the operands must traverse the association

The intention behind this restriction is to produce a meaningful value for the
`ReferentialConstraint` of the resulting `NavigationProperty`.

_FIXME_: Do we want to keep that?

## (Tentative): Renaming annotations

Currently, the ODATA transformation renames various "shorthand" annotations to
their more elaborate "long form".

| Original name              | New name                                      |
| -------------------------- | --------------------------------------------- |
| `@label`                   | `@Common.Label`                               |
| `@label`                   | `@Common.Label`                               |
| `@title`                   | `@Common.Label`                               |
| `@ValueList.entity`        | `@Common.ValueList.entity`                    |
| `@ValueList.type`          | `@Common.ValueList.type`                      |
| `@Capabilities.Deletable`  | `@Capabilities.DeleteRestrictions.Deletable`  |
| `@Capabilities.Insertable` | `@Capabilities.InsertRestrictions.Insertable` |
| `@Capabilities.Updatable`  | `@Capabilities.UpdateRestrictions.Updatable`  |
| `@readonly`                | `@Core.Immutable`                             |
| `@important`               | `@UI.Importance`                              |


For the annotation `@important` (which is renamed to `@UI.Importance`), the
values `true`/`false` are also replaced by the enum constants `#High`/`#Low`.

_FIXME_: Do we want to keep that?
