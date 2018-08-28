using BookingService as srv from './booking-service';

annotate srv.Itineraries with {
  ID   @UI.TextArrangement: #TextOnly;
};
annotate srv.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);

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
  CustomerName
    @title: 'Customer'
    @Common.FieldControl: #Mandatory;
  EmailAddress
    @title: 'Email'
    @Common.FieldControl: #Mandatory;
  Itinerary
    @Common: {
      Label : 'Trip',
      FieldControl: #Mandatory,
      Text: {$value: Itinerary.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: { entity: 'Itineraries' }
    };
};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName, Label: 'Customer'},
    {$Type: 'UI.DataField', Value: Itinerary.Name, Label : 'Trip'},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],

  UI.HeaderInfo: {
    Title: { Value: Itinerary.Name },
    Description: { Value: CustomerName },
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
      {$Type: 'UI.DataField', Value: CustomerName},
      {$Type: 'UI.DataField', Value: EmailAddress},
      {$Type: 'UI.DataField', Value: NumberOfPassengers}
    ]
  }
);
