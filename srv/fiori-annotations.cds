using BookingService as srv from './booking-service';

annotate srv.Customers with {
  ID
    @title: 'ID'
    @UI.TextArrangement: #TextOnly;
  Name  @title: 'Name';
  Email @title: 'Email';
};
annotate srv.Customers with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);

annotate srv.Bookings with {
  ID
    @title: 'Id';
  NumberOfPassengers
    @title: 'Passengers';
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
  Customer
    @Common: {
      Label: 'Customer',
      FieldControl: #Mandatory,
      Text: {$value: Customer.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: { entity: 'Customers' }
    };
};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: Customer.Name, Label: 'Customer'},
    {$Type: 'UI.DataField', Value: Itinerary.Name},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],

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
        {$Type: 'UI.DataField', Value: Itinerary_ID, Label: 'Trip'},
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
