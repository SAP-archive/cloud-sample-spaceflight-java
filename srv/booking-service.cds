using teched.flight.trip as flight from '../db/space-model';
using teched.space.trip as space from '../db/space-model';
using API_BUSINESS_PARTNER as bp from './external/csn/API_BUSINESS_PARTNER';


service BookingService {

  @cds.persistence.skip
  @readonly entity Customers as projection on bp.A_BusinessPartnerType {
    BusinessPartner as ID,
    LastName,
    FirstName
    // to_BusinessPartnerAddress.to_EmailAddress.EmailAddress as email
  };

  extend entity flight.Bookings {
    // actually: Association to Customers
    Customer: Customers.ID;
  };

  entity Bookings as projection on flight.Bookings;
  entity Itineraries as projection on flight.Itineraries;

  @readonly entity EarthRoutes as projection on flight.EarthRoutes;
  @readonly entity Airports as projection on flight.Airports;
  @readonly entity Airlines as projection on flight.Airlines;

  @readonly entity SpaceRoutes as projection on space.SpaceRoutes;
  @readonly entity Spaceports as projection on space.Spaceports;
  @readonly entity Spacelines as projection on space.SpaceFlightCompanies;
  @readonly entity Planets as projection on space.AstronomicalBodies;


  // workaround until edm2csn 1.0.1, which includes these annotations automatically
  annotate bp.A_AddressEmailAddressType with @cds.persistence.skip;
  annotate bp.A_AddressFaxNumberType with @cds.persistence.skip;
  annotate bp.A_AddressHomePageURLType with @cds.persistence.skip;
  annotate bp.A_AddressPhoneNumberType with @cds.persistence.skip;
  annotate bp.A_BPContactToAddressType with @cds.persistence.skip;
  annotate bp.A_BPContactToFuncAndDeptType with @cds.persistence.skip;
  annotate bp.A_BuPaAddressUsageType with @cds.persistence.skip;
  annotate bp.A_BuPaIdentificationType with @cds.persistence.skip;
  annotate bp.A_BusinessPartnerAddressType with @cds.persistence.skip;
  annotate bp.A_BusinessPartnerBankType with @cds.persistence.skip;
  annotate bp.A_BusinessPartnerContactType with @cds.persistence.skip;
  annotate bp.A_BusinessPartnerRoleType with @cds.persistence.skip;
  annotate bp.A_BusinessPartnerTaxNumberType with @cds.persistence.skip;
  annotate bp.A_BusinessPartnerType with @cds.persistence.skip;
  annotate bp.A_CustSalesPartnerFuncType with @cds.persistence.skip;
  annotate bp.A_CustomerCompanyType with @cds.persistence.skip;
  annotate bp.A_CustomerDunningType with @cds.persistence.skip;
  annotate bp.A_CustomerSalesAreaTaxType with @cds.persistence.skip;
  annotate bp.A_CustomerSalesAreaType with @cds.persistence.skip;
  annotate bp.A_CustomerType with @cds.persistence.skip;
  annotate bp.A_CustomerWithHoldingTaxType with @cds.persistence.skip;
  annotate bp.A_SupplierCompanyType with @cds.persistence.skip;
  annotate bp.A_SupplierDunningType with @cds.persistence.skip;
  annotate bp.A_SupplierPartnerFuncType with @cds.persistence.skip;
  annotate bp.A_SupplierPurchasingOrgType with @cds.persistence.skip;
  annotate bp.A_SupplierType with @cds.persistence.skip;
  annotate bp.A_SupplierWithHoldingTaxType with @cds.persistence.skip;

}

