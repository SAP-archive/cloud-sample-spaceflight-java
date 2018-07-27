
// ---------------------------------------------------------------------------------------------------------------------
// A service to fetch remote Customer data on explicit trigger
// ---------------------------------------------------------------------------------------------------------------------
service ReplicationService {
  @cds.persistence.skip entity dummy {key ID: UUID;}; // see cap/issues#289

  function fetchCustomers() returns Integer; // number of customers fetched
}
