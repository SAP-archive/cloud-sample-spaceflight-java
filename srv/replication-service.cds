
// ---------------------------------------------------------------------------------------------------------------------
// A service to fetch remote Customer data on explicit trigger
// ---------------------------------------------------------------------------------------------------------------------
service ReplicationService {
  @cds.persistence.skip entity dummy {key ID: UUID;};
  function fetchCustomers() returns Integer; // number of customers fetched
}
