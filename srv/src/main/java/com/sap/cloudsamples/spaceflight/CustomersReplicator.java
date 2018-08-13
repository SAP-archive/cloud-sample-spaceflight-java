package com.sap.cloudsamples.spaceflight;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.s4hana.connectivity.ErpConfigContext;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.AddressEmailAddress;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartnerAddress;
import com.sap.cloud.sdk.service.prov.api.DataSourceHandler;
import com.sap.cloud.sdk.service.prov.api.EntityData;
import com.sap.cloud.sdk.service.prov.api.ExtensionHelper;
import com.sap.cloud.sdk.service.prov.api.annotations.Function;
import com.sap.cloud.sdk.service.prov.api.exception.DatasourceException;
import com.sap.cloud.sdk.service.prov.api.request.OperationRequest;
import com.sap.cloud.sdk.service.prov.api.response.OperationResponse;
import com.sap.cloudsamples.spaceflight.s4.BusinessPartnerQuery;
import com.sap.cloudsamples.spaceflight.s4.BusinessPartnerRead;

/**
 * Helper class for fetching customers from remote
 */
public class CustomersReplicator {

	/**
	 * The destination we use to contact the remote end-point. Must be configured in
	 * Cloud Cockpit.
	 */
	private static final String DESTINATION_NAME_S4 = "ErpQueryEndpoint";

	private static final int MAX_NO_TO_REPLICATE = 50; // restrict number of records to fetch
	private static final String CUSTOMERS_ENTITY = "teched.flight.trip.Customers";
	private static final Logger logger = LoggerFactory.getLogger(CustomersReplicator.class);

	/**
	 * Called on execution of the <code>fetchCustomers</code> function
	 */
	@Function(Name = "fetchCustomers")
	public OperationResponse fetchAndStoreCustomers(OperationRequest opReq, ExtensionHelper extHelper)
			throws ODataException {
		// fetch from remote
		List<Customer> customers = fetchCustomers(true, -1, -1);

		// save to local DB
		DataSourceHandler dataSource = extHelper.getHandler();
		customers.stream().forEach(customer -> saveCustomer(customer, dataSource));

		// return number of fetched customers
		return OperationResponse.setSuccess().setPrimitiveData(Collections.singletonList(customers.size())).response();
	}

	/**
	 * Fetches one customer
	 */
	static Customer fetchCustomer(String id, boolean includeAddressData) {
		BusinessPartner bp = new BusinessPartnerRead(new ErpConfigContext(DESTINATION_NAME_S4), id).execute();
		Customer customer = Customer.fromBusinessPartner(bp);
		if (includeAddressData) {
			fetchAddressData(customer);
		}
		return customer;
	}

	/**
	 * Fetches multiple customers
	 */
	static List<Customer> fetchCustomers(boolean includeAddressData, int top, int skip) {
		BusinessPartnerQuery query = new BusinessPartnerQuery( //
				new ErpConfigContext(DESTINATION_NAME_S4), //
				top >= 0 ? top : MAX_NO_TO_REPLICATE, //
				skip >= 0 ? skip : -1, //
				Arrays.asList( // properties to fetch
						BusinessPartner.BUSINESS_PARTNER.getFieldName(),
						BusinessPartner.BUSINESS_PARTNER_FULL_NAME.getFieldName() //
				), //
				Collections.emptyList(), //
				BusinessPartner.IS_NATURAL_PERSON.eq("X") // only fetch natural persons
		);

		// fetch basic BP data from remote
		List<BusinessPartner> businessPartners = query.execute();

		// convert them to Customer objects
		List<Customer> customers = businessPartners.stream().map(Customer::fromBusinessPartner)
				.collect(Collectors.toList());

		// fetch additional address data (in parallel threads to improve performance)
		if (includeAddressData) {
			customers.parallelStream().forEach(customer -> fetchAddressData(customer));
		}
		return customers;
	}

	/**
	 * Stores the given customer in the local DB
	 */
	static Customer saveCustomer(Customer customer, DataSourceHandler dataSource) {
		try {
			logger.info("Storing " + customer.getId());
			upsert(customer, CUSTOMERS_ENTITY, Customer.ID_PROP, customer.getId(), dataSource);
			return customer;
		} catch (DatasourceException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	/**
	 * Fetches additional address data for the given customer
	 */
	private static Customer fetchAddressData(Customer customer) {
		try {
			logger.info("Fetching address for " + customer.getId());
			BusinessPartner bp = customer.businessPartner;
			List<BusinessPartnerAddress> addresses = bp.getBusinessPartnerAddressOrFetch(); // potential remote call
			for (BusinessPartnerAddress address : addresses) {
				List<AddressEmailAddress> emailAddresses = address.getEmailAddressOrFetch(); // potential remote call
				emailAddresses.stream() //
						.filter(addr -> addr.getEmailAddress() != null && addr.getEmailAddress().length() > 0) //
						.findFirst() //
						.ifPresent(addr -> customer.setEmail(addr.getEmailAddress())); // set email in customer
			}
		} catch (ODataException e) {
			logger.error(e.getMessage(), e);
		}
		return customer;
	}

	/**
	 * Either insert or update the given entity
	 */
	private static void upsert(Object pojo, String entityName, String idProp, String id, DataSourceHandler dataSource)
			throws DatasourceException {
		Map<String, Object> keys = Collections.singletonMap(idProp, id);
		EntityData existingCustomer = dataSource.executeRead(entityName, keys, Collections.singletonList(idProp));
		if (existingCustomer != null) {
			dataSource.executeUpdate(EntityData.createFrom(pojo, entityName), keys, false);
		} else {
			dataSource.executeInsert(pojo, entityName, false);
		}
	}

}
