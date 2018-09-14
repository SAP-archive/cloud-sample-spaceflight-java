using BookingService as srv from './booking-service';

// ---------------------------------------------------------------------------------------------------------------------
// Customers
// ---------------------------------------------------------------------------------------------------------------------
annotate srv.Customers with {
  ID
    @title: 'ID'
    @UI.TextArrangement: #TextOnly;
  Name  @title: 'Name';
  Email
    @title: 'Email'
    @Common.FieldControl: #ReadOnly;
};
annotate srv.Customers with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);
annotate srv.CustomersRemote with {
  ID    @title: 'ID';
  Name  @title: 'Name';
  Email @title: 'Email';
};
annotate srv.CustomersRemote with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);

// ---------------------------------------------------------------------------------------------------------------------
// Itineraries
// ---------------------------------------------------------------------------------------------------------------------
annotate srv.Itineraries with {
  ID   @UI.TextArrangement: #TextOnly;
};
annotate srv.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);

// ---------------------------------------------------------------------------------------------------------------------
// Bookings
// ---------------------------------------------------------------------------------------------------------------------
annotate srv.Bookings with {
  ID
    @title: 'Id';
  BookingNo
    @title: 'Booking number';
  DateOfTravel
    @title: 'Travel date'
    @Common.FieldControl: #Mandatory;
  NumberOfPassengers
    @title: 'Passengers';
  Cost
    @title: 'Cost'
    @Common.FieldControl: #Mandatory;
  Itinerary
    @Common: {
      Label : 'Trip',
      FieldControl: #Mandatory,
      Text: {$value: Itinerary.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: { entity: 'Itineraries' }
    };
  Customer
    @Common: {
      Label: 'Customer',
      FieldControl: #Mandatory,
      Text: {$value: Customer.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: { entity: 'CustomersRemote' }
    };
};
annotate srv.Bookings with @(
  // for ListPage (list of bookings)
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: Customer.Name, Label: 'Customer'},
    {$Type: 'UI.DataField', Value: Itinerary.Name, Label : 'Trip'},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],
  // for object page (booking details)
  UI.HeaderInfo: {
    Title: { Value: Itinerary.Name },
    Description: { Value: Customer.Name },
    TypeName: 'Booking',
    TypeNamePlural: 'Bookings'
  },
  UI.HeaderFacets: [
    { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#HeaderInfo' }
  ],
  UI.Identification: [
    { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#GeneralInfo' }
  ],
  UI.Facets: [
    {
      $Type:'UI.CollectionFacet',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Label: 'General Info',  Target: '@UI.FieldGroup#GeneralInfo' },
        { $Type: 'UI.ReferenceFacet', Label: 'Customer Info', Target: '@UI.FieldGroup#Customer' },
      ],
      Label:'Booking Details',
    }
  ],
  UI.FieldGroup#HeaderInfo: {
    Label: 'Header Info',
    Data: [
      {$Type: 'UI.DataField', Value: BookingNo}
    ]
  },
  UI.FieldGroup#GeneralInfo: {
    Label: 'General Info',
    Data: [
      {$Type: 'UI.DataField', Value: Itinerary_ID, Label: 'Trip'},
      {$Type: 'UI.DataField', Value: DateOfTravel},
      {$Type: 'UI.DataField', Value: Cost},
    ]
  },
  UI.FieldGroup#Customer: {
    Label: 'Customer',
    Data: [
      {$Type: 'UI.DataField', Value: Customer_ID, Label: 'Customer'}, // customer ID from external service
      {$Type: 'UI.DataField', Value: Customer.Email},
      {$Type: 'UI.DataField', Value: NumberOfPassengers}
    ]
  }
);
