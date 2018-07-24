using BookingService as srv from './booking-service';

annotate srv.Bookings with {
  ID
    @title: 'Id';
  CustomerName
    @title: 'Customer';
  NumberOfPassengers
    @title: 'Passengers';
  EmailAddress
    @title: 'Email'
    @Common.FieldControl: #Optional;
  DateOfBooking
    @title: 'Booking date'
    @odata.on.insert: #now;
  DateOfTravel
    @title: 'Travel date'
    @Common.FieldControl: #Mandatory;
  Cost
    @title: 'Cost'
    @Common.FieldControl: #Mandatory;
  Itinerary
    // @sap.value.list: 'fixed-values'
    @Common: {
      Label : 'Trip',
      FieldControl: #Mandatory,
      Text: {$value: Itinerary.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: {
        entity: 'Itineraries',
        type: #fixed,
        //CollectionPath: 'Itinerary',
        //Label: 'Trip',
        SearchSupported: true,
        //Parameters: [
        //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: Itinerary_ID', ValueListProperty: 'ID'},
        //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
        //]
      },
      ValueListWithFixedValues
    };
};

annotate srv.Bookings with {
  Customer
    @Common.FieldControl: #Mandatory
    @Common.Text: {$value: CustomerName, "@UI.TextArrangement": #TextFirst};
};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName},
    {$Type: 'UI.DataField', Value: Itinerary.Name},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],

  UI.HeaderInfo: {
    Title: { Value: CustomerName },
    Description: { Value: Itinerary.Name },
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
      // ,{$Type:'UI.ReferenceFacet', Label: 'Orders', Target: 'orders/@UI.LineItem'},
    ],
    UI.FieldGroup#HeaderInfo: {
      Label: 'Header Info',
      Data: [
        {$Type: 'UI.DataField', Value: DateOfTravel},
        {$Type: 'UI.DataField', Value: Cost},
        {$Type: 'UI.DataField', Value: Itinerary_ID},
        {$Type: 'UI.DataField', Value: ID}
      ]
    },
    UI.FieldGroup#GeneralInfo: {
      Label: 'General Info',
      Data: [
        {$Type: 'UI.DataField', Value: DateOfBooking},
        {$Type: 'UI.DataField', Value: DateOfTravel},
        {$Type: 'UI.DataField', Value: Cost},
        {$Type: 'UI.DataField', Value: Itinerary_ID},
      ]
    },
    UI.FieldGroup#Customer: {
      Label: 'Customer',
      Data: [
        {$Type: 'UI.DataField', Value: Customer}, // customer ID from external service
        {$Type: 'UI.DataField', Value: EmailAddress},
        {$Type: 'UI.DataField', Value: NumberOfPassengers}
      ]
    }
);
