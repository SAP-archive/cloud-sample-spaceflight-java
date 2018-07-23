package com.sap.cloudsamples.spaceflight;

import java.util.List;
import java.util.stream.Collectors;

import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.s4hana.connectivity.ErpConfigContext;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.service.prov.api.operations.Query;
import com.sap.cloud.sdk.service.prov.api.operations.Read;
import com.sap.cloud.sdk.service.prov.api.request.QueryRequest;
import com.sap.cloud.sdk.service.prov.api.request.ReadRequest;
import com.sap.cloud.sdk.service.prov.api.response.QueryResponse;
import com.sap.cloud.sdk.service.prov.api.response.ReadResponse;
import com.sap.cloudsamples.spaceflight.s4.BusinessPartnerQuery;
import com.sap.cloudsamples.spaceflight.s4.BusinessPartnerRead;

public class CustomersHandler {

	private static final String BOOKING_SERVICE = "BookingService";
	static final String CUSTOMERS = "Customers";

	// private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Read(serviceName = BOOKING_SERVICE, entity = CUSTOMERS)
	public ReadResponse readSingleCustomerByKey(ReadRequest readRequest) throws ODataException {
		String id = String.valueOf(readRequest.getKeys().get(Customer.ID_PROP));
		BusinessPartner bp = new BusinessPartnerRead(new ErpConfigContext(), id).execute();
		Customer customer = Customer.fromBusinessPartner(bp);
		CustomersLoader.fetchAddressData(customer);

		ReadResponse readResponse = ReadResponse.setSuccess().setData(customer).response();
		return readResponse;
	}

	@Query(serviceName = BOOKING_SERVICE, entity = CUSTOMERS)
	public QueryResponse queryCustomers(QueryRequest qryRequest) throws ODataException {

		BusinessPartnerQuery query = new BusinessPartnerQuery( //
				new ErpConfigContext(), //
				qryRequest.getTopOptionValue(), qryRequest.getSkipOptionValue(), //
				qryRequest.getSelectProperties(), //
				qryRequest.getOrderByProperties(), //
				BusinessPartner.CUSTOMER.ne(""));

		List<BusinessPartner> businessPartners = query.execute();
		boolean includeAddress = qryRequest.getSelectProperties().contains(Customer.EMAIL_PROP);

		List<Customer> customers = businessPartners.stream().map(bp -> {
			Customer customer = Customer.fromBusinessPartner(bp);
			if (includeAddress) {
				CustomersLoader.fetchAddressData(customer);
			}
			return customer;
		}).collect(Collectors.toList());

		QueryResponse queryResponse = QueryResponse.setSuccess().setData(customers).response();
		return queryResponse;
	}

}
