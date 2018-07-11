package com.sap.cloudsamples.spaceflight;

import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
	private static final String ENTITY_CUSTOMERS = "Customers";
	private static final String PROPERTY_CUSTOMERS_ID = "ID";

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Read(serviceName = BOOKING_SERVICE, entity = ENTITY_CUSTOMERS)
	public ReadResponse readSingleCustomerByKey(ReadRequest readRequest) {
		logger.info("Received the following keys: {} ", readRequest.getKeys().entrySet().stream()
				.map(x -> x.getKey() + ":" + x.getValue()).collect(Collectors.joining(" | ")));

		String id = String.valueOf(readRequest.getKeys().get(PROPERTY_CUSTOMERS_ID));
		BusinessPartner partner = new BusinessPartnerRead(new ErpConfigContext(), id).execute();
		partner.setCustomField(PROPERTY_CUSTOMERS_ID, id);

		ReadResponse readResponse = ReadResponse.setSuccess().setData(partner).response();
		return readResponse;
	}

	@Query(serviceName = BOOKING_SERVICE, entity = ENTITY_CUSTOMERS)
	public QueryResponse queryCustomers(QueryRequest qryRequest) {

		List<BusinessPartner> businessPartners = new BusinessPartnerQuery(new ErpConfigContext(),
				qryRequest.getTopOptionValue(), qryRequest.getSkipOptionValue(), qryRequest.getSelectProperties(),
				qryRequest.getOrderByProperties()).execute();

		businessPartners.forEach(bp -> bp.setCustomField(PROPERTY_CUSTOMERS_ID, bp.getBusinessPartner()));

		QueryResponse queryResponse = QueryResponse.setSuccess().setData(businessPartners).response();
		return queryResponse;
	}
}
