package com.sap.cloudsamples.spaceflight;

import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.service.prov.api.annotations.Key;

/**
 * DAO class for the Customers entity, holding ID, name, and email
 */
public class Customer {

	static final String ID_PROP = "ID";
	static final String NAME_PROP = "Name";
	static final String EMAIL_PROP = "Email";

	/**
	 * Creates an instance out of a remote {@link BusinessPartner}
	 */
	public static Customer fromBusinessPartner(BusinessPartner bp) {
		Customer customer = new Customer(bp.getBusinessPartner(), bp.getBusinessPartnerFullName());
		customer.businessPartner = bp; // transiently store BP along with the Customer for convenience
		return customer;
	}

	@Key
	private volatile String ID;
	private volatile String Name;
	private volatile String Email;
	transient volatile BusinessPartner businessPartner;

	Customer(String id, String name) {
		this.ID = id;
		this.Name = name;
	}

	public String getId() {
		return ID;
	}

	public void setId(String id) {
		this.ID = id;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		this.Name = name;
	}

	public String getEmail() {
		return Email;
	}

	public void setEmail(String email) {
		this.Email = email;
	}

	@Override
	public String toString() {
		return "Customer [id=" + ID + ", name=" + Name + ", email=" + Email + "]";
	}


}
