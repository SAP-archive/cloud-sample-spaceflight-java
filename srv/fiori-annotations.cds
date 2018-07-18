using BookingService as srv from './booking-service';
using teched.flight.trip as flight from '../db/space-model';

annotate flight.Itineraries with {
  ID
    @Common.Label : 'Itinerary ID'
    @UI.TextArrangement: #TextOnly;
  Name
    @Capabilities.SearchRestrictions.Searchable;
};
annotate srv.EarthItineraries with {
  // Name @Common.Label : 'Earth Trip';
  Name @Common.Label : 'Trip';
};
annotate srv.SpaceItineraries with {
  Name @Common.Label : 'Space Trip';
};
annotate flight.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
){ // element-level annotations
  ID @UI.HiddenFilter;
  Name @UI.HiddenFilter;
};

annotate srv.Bookings with {
  ID
    @Common.Label : 'Id'
    @Core.Immutable;
  CustomerName
    @Common.Label : 'Customer';
  NumberOfPassengers
    @Common.Label : 'Passengers';
  EmailAddress
    @Common.Label : 'Email'
    @Common.FieldControl: #Optional;
  DateOfBooking
    @Common.Label : 'Booking date'
    @odata.on.insert: #now;
  DateOfTravel
    @Common.Label : 'Travel date'
    @Common.FieldControl: #Mandatory;
  Cost
    @Common.Label : 'Cost'
    @Common.FieldControl: #Mandatory;
  EarthItinerary
    // @sap.value.list: 'fixed-values'
    @Common: {
      Label : 'Earth Trip',
      FieldControl: #Mandatory,
      Text: {$value: EarthItinerary.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: {
        entity: 'EarthItineraries',
        type: #fixed,
        //CollectionPath: 'EarthItinerary',
        //Label: 'Trip',
        SearchSupported: true,
        //Parameters: [
        //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: EarthItinerary_ID', ValueListProperty: 'ID'},
        //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
        //]
      },
      ValueListWithFixedValues
    };
    SpaceItinerary
      // @sap.value.list: 'fixed-values'
      @Common: {
        Label : 'Space Trip',
        FieldControl: #Mandatory,
        Text: {$value: SpaceItinerary.Name, "@UI.TextArrangement": #TextOnly},
        ValueList: {
          entity: 'SpaceItineraries',
          type: #fixed,
          //CollectionPath: 'SpaceItinerary',
          //Label: 'Trip',
          SearchSupported: true,
          //Parameters: [
          //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: SpaceItinerary_ID', ValueListProperty: 'ID'},
          //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
          //]
      },
      ValueListWithFixedValues
    };

};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName},
    {$Type: 'UI.DataField', Value: EarthItinerary.Name},
    // {$Type: 'UI.DataField', Value: SpaceItinerary.Name},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],

  UI.HeaderInfo: {
    Title: { Value: CustomerName },
    // Description: { Value: EarthItinerary.Name },
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
      {$Type: 'UI.DataField', Value: EarthItinerary_ID},
      {$Type: 'UI.DataField', Value: SpaceItinerary_ID},
    	{$Type: 'UI.DataField', Value: ID}
    ]
  },
  UI.FieldGroup#GeneralInfo: {
    Label: 'General Info',
    Data: [
      {$Type: 'UI.DataField', Value: DateOfBooking},
      {$Type: 'UI.DataField', Value: DateOfTravel},
      {$Type: 'UI.DataField', Value: Cost},
      {$Type: 'UI.DataField', Value: EarthItinerary_ID},
      {$Type: 'UI.DataField', Value: SpaceItinerary_ID},
    ]
  },
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
