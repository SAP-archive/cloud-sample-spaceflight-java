using BookingService as srv from './booking-service';

annotate srv.Itineraries with {
  ID
    @Common.Label : 'Itinerary';
};


annotate srv.Bookings with {
  ID
    @Common.Label : 'Id'
    @Core.Immutable;
  CustomerName
    @Common.Label : 'Customer'
    @Common.FieldControl: #Mandatory;
  NumberOfPassengers
    @Common.Label : 'Passengers';
  EmailAddress
    @Common.Label : 'Email'
    @Common.FieldControl: #Mandatory;
  DateOfBooking
    @Common.Label : 'Booking date';
  DateOfTravel
    @Common.Label : 'Travel date'
    @Common.FieldControl: #Mandatory;
  Cost
    @Common.Label : 'Cost'
    @Common.FieldControl: #Mandatory;
  Itinerary
    @Common.Label : 'Itinerary'
    @Common.FieldControl: #Mandatory
    // @sap.value.list: 'fixed-values'
    @Common.ValueList: {
      Entity: 'Itinerary',
      type: #fixed,
      CollectionPath: 'Itinerary',
      Label: 'Itinerary',
      SearchSupported: 'true',
      Parameters: [
        { $Type: 'Common.ValueListParameterOut', LocalDataProperty: 'Itinerary_ID', ValueListProperty: 'ID'},
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
      ]
    };

};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: EmailAddress},
    {$Type: 'UI.DataField', Value: DateOfBooking},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: Itinerary_ID},
  ],

  UI.HeaderInfo: {
    Title: { Value: CustomerName },
    Description: { Value: ID },
    TypeName: 'Booking',
    TypeNamePlural: 'Bookings'
  },

  UI.Identification:
  [
    {$Type: 'UI.DataField', Value: DateOfBooking},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: Itinerary_ID},
  ],

  UI.Facets:
  [
    {
      $Type:'UI.CollectionFacet',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Label: 'General Info', Target: '@UI.Identification' },
        { $Type: 'UI.ReferenceFacet', Label: 'Customer', Target: '@UI.FieldGroup#Customer' },
      ],
      Label:'Booking Details',
    }
    // ,{$Type:'UI.ReferenceFacet', Label: 'Orders', Target: 'orders/@UI.LineItem'},
  ],
  UI.FieldGroup#Customer: {
    Label: 'Customer',
    Data: [
      {$Type: 'UI.DataField', Value: '???', Label: 'ID'}, // customer ID from external service
      {$Type: 'UI.DataField', Value: CustomerName},
      {$Type: 'UI.DataField', Value: EmailAddress},
	  {$Type: 'UI.DataField', Value: NumberOfPassengers}
    ]
  },

);
