package com.sap.cloudsamples.spaceflight;

import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.service.prov.api.annotations.Key;

public class Customer {

	static final String ID_PROP = "ID";
	static final String NAME_PROP = "Name";
	static final String EMAIL_PROP = "Email";

	static final String ENTITY_NAME = "teched.flight.trip.Customers";

	public static Customer fromBusinessPartner(BusinessPartner bp) {
		Customer customer = new Customer(bp.getBusinessPartner(), bp.getBusinessPartnerFullName());
		customer.businessPartner = bp;
		return customer;
	}

	@Key
	private volatile String id;
	private volatile String name;
	private volatile String email;

	transient volatile BusinessPartner businessPartner;

	public Customer() {
	}

	public Customer(String id, String name) {
		this.id = id;
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Override
	public String toString() {
		return "Customer [id=" + id + ", name=" + name + ", email=" + email + "]";
	}


}
