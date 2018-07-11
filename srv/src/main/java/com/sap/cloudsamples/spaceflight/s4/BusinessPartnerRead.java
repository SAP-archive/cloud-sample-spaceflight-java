package com.sap.cloudsamples.spaceflight.s4;

import com.netflix.hystrix.exception.HystrixBadRequestException;
import com.sap.cloud.sdk.odatav2.connectivity.ODataException;
import com.sap.cloud.sdk.s4hana.connectivity.ErpCommand;
import com.sap.cloud.sdk.s4hana.connectivity.ErpConfigContext;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartnerByKeyFluentHelper;
import com.sap.cloud.sdk.s4hana.datamodel.odata.services.DefaultBusinessPartnerService;

public class BusinessPartnerRead extends ErpCommand<BusinessPartner> {

	private final ErpConfigContext erpConfigContext;
	private String businessPartner;

	public BusinessPartnerRead(ErpConfigContext erpConfigContext, String businessPartner) {
		super(BusinessPartnerRead.class, erpConfigContext);
		this.businessPartner = businessPartner;
		this.erpConfigContext = erpConfigContext;
	}

	@Override
	protected BusinessPartner run() {

		BusinessPartnerByKeyFluentHelper service = new DefaultBusinessPartnerService()
				.getBusinessPartnerByKey(businessPartner);

		try {
			return service.execute(erpConfigContext);
		} catch (final ODataException e) {
			throw new HystrixBadRequestException(e.getMessage(), e);
		}
	}
}