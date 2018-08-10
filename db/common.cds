namespace common;

// ---------------------------------------------------------------------------------------------------------------------
// Define an ID field to be of type UUID (Universal Unique Identifier).
// Such a field is typically used as a key field and the UUID value is generated automatically.
// ---------------------------------------------------------------------------------------------------------------------
abstract entity Managed {
  key ID : UUID;
}
