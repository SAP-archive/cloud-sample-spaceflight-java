package com.sap.cloudsamples.spaceflight;

import java.util.List;

import com.sap.cloud.sdk.cloudplatform.ScpCfCloudPlatformFacade;
import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.service.prov.api.operations.Query;
import com.sap.cloud.sdk.service.prov.api.operations.Read;
import com.sap.cloud.sdk.service.prov.api.request.QueryRequest;
import com.sap.cloud.sdk.service.prov.api.request.ReadRequest;
import com.sap.cloud.sdk.service.prov.api.response.QueryResponse;
import com.sap.cloud.sdk.service.prov.api.response.ReadResponse;

/**
 * Request handler for <code>BookingService.CustomersRemote</code> entity.
 */
public class CustomersRemoteHandler {

	static {
		System.out.println(new ScpCfCloudPlatformFacade().getCloudPlatform().getXsuaaServiceCredentialsList());
	}

	private static final String CUSTOMERSREMOTE = "CustomersRemote";

	// private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * Called on read of a single customer
	 */
	@Read(serviceName = BookingsHandler.BOOKING_SERVICE, entity = CUSTOMERSREMOTE)
	public ReadResponse readSingleCustomerByKey(ReadRequest readRequest) throws ODataException {
		// fetch the given customer from remote
		String id = String.valueOf(readRequest.getKeys().get(Customer.ID_PROP));

//		Customer customer = new Customer(id, "<n/a>");     // create dummy customer if no external service is used
		Customer customer = CustomersReplicator.fetchCustomer(id, true);  // get customer from S/4 if external service has been imported

		return ReadResponse.setSuccess().setData(customer).response();
	}

	/**
	 * Called on query for a set of customers
	 */
	@Query(serviceName = BookingsHandler.BOOKING_SERVICE, entity = CUSTOMERSREMOTE)
	public QueryResponse queryCustomers(QueryRequest qryRequest) throws ODataException {

		// fetch the queried set of customers from remote
		boolean includeAddress = qryRequest.getSelectProperties().contains(Customer.EMAIL_PROP);
		int top = qryRequest.getTopOptionValue();
		int skip = qryRequest.getSkipOptionValue();

//		List<Customer> customers = Collections.emptyList(); // empty list if no external service is used
		List<Customer> customers = CustomersReplicator.fetchCustomers(includeAddress, top, skip); // fetch customers if external service is used

		return QueryResponse.setSuccess().setData(customers).response();
	}

}
