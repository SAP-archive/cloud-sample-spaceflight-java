package com.sap.cloudsamples.spaceflight;

import org.apache.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.s4hana.connectivity.ErpConfigContext;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.service.prov.api.EntityData;
import com.sap.cloud.sdk.service.prov.api.EntityDataBuilder;
import com.sap.cloud.sdk.service.prov.api.ExtensionHelper;
import com.sap.cloud.sdk.service.prov.api.annotations.BeforeCreate;
import com.sap.cloud.sdk.service.prov.api.annotations.BeforeUpdate;
import com.sap.cloud.sdk.service.prov.api.exits.BeforeCreateResponse;
import com.sap.cloud.sdk.service.prov.api.exits.BeforeUpdateResponse;
import com.sap.cloud.sdk.service.prov.api.exits.PreExtensionResponseBuilderWithBody;
import com.sap.cloud.sdk.service.prov.api.exits.PreExtensionResponseImpl;
import com.sap.cloud.sdk.service.prov.api.exits.PreExtensionResponseWithBody;
import com.sap.cloud.sdk.service.prov.api.request.CreateRequest;
import com.sap.cloud.sdk.service.prov.api.request.UpdateRequest;
import com.sap.cloud.sdk.service.prov.api.response.ErrorResponse;
import com.sap.cloudsamples.spaceflight.s4.BusinessPartnerRead;

public class BookingsHandler {

	private static final String BOOKING_SERVICE = "BookingService";
	private static final String ENTITY_BOOKINGS = "Bookings";
	private static final String PROPERTY_CUSTOMER = "Customer";
	private static final String PROPERTY_EMAIL = "EmailAddress";

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@BeforeCreate(serviceName = BOOKING_SERVICE, entity = ENTITY_BOOKINGS)
	public BeforeCreateResponse beforeBookingCreate(CreateRequest req, ExtensionHelper helper)
			throws ODataException {
		return beforeUpsert(req.getData());
	}

	@BeforeUpdate(serviceName = BOOKING_SERVICE, entity = ENTITY_BOOKINGS)
	public BeforeUpdateResponse beforeBookingUpdate(UpdateRequest req, ExtensionHelper helper) throws ODataException {
		return beforeUpsert(req.getData());
	}

	private PreExtensionResponseWithBody beforeUpsert(EntityData reqData) throws ODataException {
		EntityDataBuilder entityBuilder = EntityData.getBuilder(reqData);
		BusinessPartner bPartner = null;

		// fetch BP
		if (reqData.contains(PROPERTY_CUSTOMER)) {
			String customerId = (String) reqData.getElementValue(PROPERTY_CUSTOMER);

			try {
				bPartner = new BusinessPartnerRead(new ErpConfigContext(), customerId).execute();
			} catch (Exception e) {
				logger.info(e.getMessage(), e);
				return new PreExtensionResponseImpl(ErrorResponse.getBuilder().setStatusCode(HttpStatus.SC_BAD_REQUEST)
						.setMessage("NoSuchCustomer", customerId)
						.addErrorDetail("NoSuchCustomer", PROPERTY_CUSTOMER, customerId).response());
			}
			CustomersHandler.completeResponseData(bPartner, true);

			entityBuilder.addElement("CustomerName", bPartner.getBusinessPartnerFullName());
		}

		// fetch email from BP
		if (bPartner != null && !reqData.contains(PROPERTY_EMAIL)) {
			entityBuilder.addElement(PROPERTY_EMAIL, bPartner.getCustomField(CustomersHandler.PROPERTY_CUSTOMERS_EMAIL))
					.buildEntityData(ENTITY_BOOKINGS);
		}

		return new PreExtensionResponseBuilderWithBody(entityBuilder.buildEntityData(ENTITY_BOOKINGS)).response();
	}
}
