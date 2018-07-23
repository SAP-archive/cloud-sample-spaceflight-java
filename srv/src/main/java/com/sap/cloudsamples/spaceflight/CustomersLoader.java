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

public class CustomersLoader {

	private static final int MAX_NO_TO_REPLICATE = 50;
	private static final Logger logger = LoggerFactory.getLogger(CustomersLoader.class);

	@Function(Name = "loadCustomers")
	public OperationResponse loadCustomers(OperationRequest opReq, ExtensionHelper extHelper) throws ODataException {
		BusinessPartnerQuery query = new BusinessPartnerQuery( //
				new ErpConfigContext(), //
				MAX_NO_TO_REPLICATE, -1, // restrict number of records to fetch
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
		customers.parallelStream().forEach(customer -> fetchAddressData(customer));

		// save to local DB
		DataSourceHandler dataSource = extHelper.getHandler();
		customers.stream().forEach(customer -> saveCustomer(customer, dataSource));

		// return number of fetched customers
		return OperationResponse.setSuccess().setPrimitiveData(Collections.singletonList(customers.size())).response();
	}

	private Customer saveCustomer(Customer customer, DataSourceHandler dataSource) {
		try {
			logger.info("Storing " + customer.getId());
			upsert(customer, Customer.ENTITY_NAME, Customer.ID_PROP, customer.getId(), dataSource);
			return customer;
		} catch (DatasourceException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

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

	static Customer fetchAddressData(Customer customer) {
		try {
			logger.info("Fetching address for " + customer.getId());
			BusinessPartner bp = customer.businessPartner;
			List<BusinessPartnerAddress> addresses = bp.getBusinessPartnerAddressOrFetch();
			for (BusinessPartnerAddress address : addresses) {
				List<AddressEmailAddress> emailAddresses = address.getEmailAddressOrFetch();
				emailAddresses.stream() //
						.filter(addr -> addr.getEmailAddress() != null && addr.getEmailAddress().length() > 0) //
						.findFirst() //
						.ifPresent(addr -> customer.setEmail(addr.getEmailAddress()));
			}
		} catch (ODataException e) {
			logger.error(e.getMessage(), e);
		}
		return customer;
	}

}
