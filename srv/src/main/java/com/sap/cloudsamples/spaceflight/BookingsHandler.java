package com.sap.cloudsamples.spaceflight;

import java.util.Collections;

import org.apache.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.s4hana.connectivity.ErpConfigContext;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.service.prov.api.DataSourceHandler;
import com.sap.cloud.sdk.service.prov.api.EntityData;
import com.sap.cloud.sdk.service.prov.api.EntityDataBuilder;
import com.sap.cloud.sdk.service.prov.api.ExtensionHelper;
import com.sap.cloud.sdk.service.prov.api.annotations.BeforeCreate;
import com.sap.cloud.sdk.service.prov.api.annotations.BeforeUpdate;
import com.sap.cloud.sdk.service.prov.api.exception.DatasourceException;
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

	private static final String PROPERTY_ID = "ID";
	private static final String BOOKING_SERVICE = "BookingService";
	private static final String ENTITY_EARTHITINERARIES = BOOKING_SERVICE + ".EarthItineraries";
	private static final String ENTITY_SPACEITINERARIES = BOOKING_SERVICE + ".SpaceItineraries";
	private static final String ENTITY_BOOKINGS = "Bookings";
	private static final String PROPERTY_BOOKING_EARTHITINERARYID = "EarthItinerary_ID";
	private static final String PROPERTY_BOOKING_SPACEITINERARYID = "SpaceItinerary_ID";
	private static final String PROPERTY_BOOKING_CUSTOMER = "Customer";
	private static final String PROPERTY_BOOKING_EMAIL = "EmailAddress";

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@BeforeCreate(serviceName = BOOKING_SERVICE, entity = ENTITY_BOOKINGS)
	public BeforeCreateResponse beforeBookingCreate(CreateRequest req, ExtensionHelper helper)
			throws ODataException, DatasourceException {
		return beforeUpsert(req.getData(), helper.getHandler());
	}

	@BeforeUpdate(serviceName = BOOKING_SERVICE, entity = ENTITY_BOOKINGS)
	public BeforeUpdateResponse beforeBookingUpdate(UpdateRequest req, ExtensionHelper helper)
			throws ODataException, DatasourceException {
		return beforeUpsert(req.getData(), helper.getHandler());
	}

	private PreExtensionResponseWithBody beforeUpsert(EntityData reqData, DataSourceHandler dataSource)
			throws ODataException, DatasourceException {
		EntityDataBuilder entityBuilder = EntityData.getBuilder(reqData);
		BusinessPartner bPartner = null;

		PreExtensionResponseWithBody response = validateItinerary(reqData, ENTITY_EARTHITINERARIES,
				PROPERTY_BOOKING_EARTHITINERARYID, dataSource);
		if (response != null) {
			return response;
		}
		response = validateItinerary(reqData, ENTITY_SPACEITINERARIES, PROPERTY_BOOKING_SPACEITINERARYID, dataSource);
		if (response != null) {
			return response;
		}

		// fetch BP
		if (reqData.contains(PROPERTY_BOOKING_CUSTOMER)) {
			String customerId = (String) reqData.getElementValue(PROPERTY_BOOKING_CUSTOMER);

			try {
				bPartner = new BusinessPartnerRead(new ErpConfigContext(), customerId).execute();
			} catch (Exception e) {
				logger.info(e.getMessage(), e);
				return constraintError("NoSuchCustomer", customerId, PROPERTY_BOOKING_CUSTOMER);
			}
			CustomersHandler.completeResponseData(bPartner, true);

			entityBuilder.addElement("CustomerName", bPartner.getBusinessPartnerFullName());
		}

		// fetch email from BP
		if (bPartner != null && !reqData.contains(PROPERTY_BOOKING_EMAIL)) {
			entityBuilder
					.addElement(PROPERTY_BOOKING_EMAIL,
							bPartner.getCustomField(CustomersHandler.PROPERTY_CUSTOMERS_EMAIL))
					.buildEntityData(ENTITY_BOOKINGS);
		}

		return new PreExtensionResponseBuilderWithBody(entityBuilder.buildEntityData(ENTITY_BOOKINGS)).response();
	}

	private static PreExtensionResponseWithBody validateItinerary(EntityData reqData, String entity, String property,
			DataSourceHandler dataSource) throws DatasourceException {
		if (reqData.contains(property)) {
			Object itineraryId = reqData.getElementValue(property);
			EntityData itinerary = dataSource.executeRead(entity, Collections.singletonMap(PROPERTY_ID, itineraryId),
					Collections.singletonList(PROPERTY_ID));
			if (itinerary == null) {
				return constraintError("NoSuchItinerary", itineraryId, property);
			}
		}
		return null;
	}

	private static PreExtensionResponseWithBody constraintError(String messageKey, Object id, String target) {
		return new PreExtensionResponseImpl(ErrorResponse.getBuilder().setStatusCode(HttpStatus.SC_BAD_REQUEST)
				.setMessage(messageKey, id).addErrorDetail(messageKey, target, id).response());
	}
}
