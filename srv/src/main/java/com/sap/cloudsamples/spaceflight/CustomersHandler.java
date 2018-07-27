package com.sap.cloudsamples.spaceflight;

import java.util.List;

import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.service.prov.api.operations.Query;
import com.sap.cloud.sdk.service.prov.api.operations.Read;
import com.sap.cloud.sdk.service.prov.api.request.QueryRequest;
import com.sap.cloud.sdk.service.prov.api.request.ReadRequest;
import com.sap.cloud.sdk.service.prov.api.response.QueryResponse;
import com.sap.cloud.sdk.service.prov.api.response.ReadResponse;

public class CustomersHandler {

	private static final String CUSTOMERSREMOTE = "CustomersRemote";

	// private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Read(serviceName = BookingsHandler.BOOKING_SERVICE, entity = CUSTOMERSREMOTE)
	public ReadResponse readSingleCustomerByKey(ReadRequest readRequest) throws ODataException {
		String id = String.valueOf(readRequest.getKeys().get(Customer.ID_PROP));
		Customer customer = CustomersReplicator.fetchCustomer(id, true);

		ReadResponse readResponse = ReadResponse.setSuccess().setData(customer).response();
		return readResponse;
	}

	@Query(serviceName = BookingsHandler.BOOKING_SERVICE, entity = CUSTOMERSREMOTE)
	public QueryResponse queryCustomers(QueryRequest qryRequest) throws ODataException {
		boolean includeAddress = qryRequest.getSelectProperties().contains(Customer.EMAIL_PROP);
		int top = qryRequest.getTopOptionValue();
		int skip = qryRequest.getSkipOptionValue();
		List<Customer> customers = CustomersReplicator.fetchCustomers(includeAddress, top, skip);

		QueryResponse queryResponse = QueryResponse.setSuccess().setData(customers).response();
		return queryResponse;
	}

}
