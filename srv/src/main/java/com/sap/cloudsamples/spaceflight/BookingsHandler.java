package com.sap.cloudsamples.spaceflight;

import java.util.Collections;

import org.apache.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
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
import com.sap.cloud.sdk.service.prov.api.response.ErrorResponseBuilder;

public class BookingsHandler {

	private static final Logger logger = LoggerFactory.getLogger(BookingsHandler.class);

	static final String BOOKING_SERVICE = "BookingService";
	private static final String PROPERTY_ID = "ID";
	private static final String ENTITY_BOOKINGS = "Bookings";

	private static final String ENTITY_ITINERARIES = BOOKING_SERVICE + ".Itineraries";
	private static final String PROPERTY_BOOKING_ITINERARYID = "Itinerary_ID";

	private static final String PROPERTY_BOOKING_CUSTOMERID = "Customer_ID";

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
		ErrorResponseBuilder errorResponseBuilder = ErrorResponse.getBuilder();
		boolean error = false;
		EntityDataBuilder entityBuilder = EntityData.getBuilder(reqData);

		error |= validateForeignKey(reqData, ENTITY_ITINERARIES, PROPERTY_BOOKING_ITINERARYID, "NoSuchItinerary",
				dataSource, errorResponseBuilder);
		error |= fetchAndSaveCustomer(reqData, dataSource, errorResponseBuilder);

		if (error) {
			return new PreExtensionResponseImpl(
					errorResponseBuilder.setStatusCode(HttpStatus.SC_BAD_REQUEST).response());
		}

		return new PreExtensionResponseBuilderWithBody(entityBuilder.buildEntityData(ENTITY_BOOKINGS)).response();
	}

	private static boolean fetchAndSaveCustomer(EntityData reqData, DataSourceHandler dataSource,
			ErrorResponseBuilder errorResponseBuilder) {
		if (reqData.contains(PROPERTY_BOOKING_CUSTOMERID)) {
			String custId = String.valueOf(reqData.getElementValue(PROPERTY_BOOKING_CUSTOMERID));
			try {
				Customer customer = CustomersLoader.loadCustomer(custId, true);
				CustomersLoader.saveCustomer(customer, dataSource);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return addErrorMessage(errorResponseBuilder, PROPERTY_BOOKING_CUSTOMERID, "NoSuchCustomer", custId);
			}
		}
		return false;
	}

	private static boolean validateForeignKey(EntityData reqData, String entityName, String fkProperty,
			String messageKey, DataSourceHandler dataSource, ErrorResponseBuilder responseBuilder)
			throws DatasourceException {
		if (reqData.contains(fkProperty)) {
			Object value = reqData.getElementValue(fkProperty);
			EntityData entity = dataSource.executeRead(entityName, Collections.singletonMap(PROPERTY_ID, value),
					Collections.singletonList(PROPERTY_ID));
			if (entity == null) {
				return addErrorMessage(responseBuilder, fkProperty, messageKey, value);
			}
		}
		return false;
	}

	private static boolean addErrorMessage(ErrorResponseBuilder responseBuilder, String target, String messageKey,
			Object... messageArgs) {
		responseBuilder.setMessage(messageKey, messageArgs).addErrorDetail(messageKey, target, messageArgs);
		return true;
	}
}
