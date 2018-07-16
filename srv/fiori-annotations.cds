using BookingService as srv from './booking-service';

annotate srv.Itineraries with {
  ID
    @Common.Label : 'Itinerary ID'
    @UI.TextArrangement: #TextOnly;
  Name
    @Common.Label : 'Itinerary'
    @Capabilities.SearchRestrictions.Searchable;
};
annotate srv.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
){ // element-level annotations
  ID @UI.HiddenFilter;
  Name @UI.HiddenFilter;
};

annotate srv.Customers with {
  ID
    @Common.Label : 'Id';
  Name
    @Common.Label : 'Name';
  Email
    @Common.Label : 'Email';
};


annotate srv.Bookings with {
  ID
    @Common.Label : 'Id'
    @Core.Immutable;
  Customer
    @Common.Label : 'Customer'
    @Common.FieldControl: #Mandatory
    @Common.Text: {$value: CustomerName, "@UI.TextArrangement": #TextFirst};
  CustomerName
    @Common.Label : 'Customer Name';
  NumberOfPassengers
    @Common.Label : 'Passengers';
  EmailAddress
    @Common.Label : 'Email';
  DateOfBooking
    @Common.Label : 'Booking date'
    @odata.on.insert: #now;
  DateOfTravel
    @Common.Label : 'Travel date'
    @Common.FieldControl: #Mandatory;
  Cost
    @Common.Label : 'Cost'
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
	      //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: 'Itinerary_ID', ValueListProperty: 'ID'},
	      //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
	      //]
		},
		ValueListWithFixedValues
    };

};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: DateOfBooking},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: Itinerary.Name},
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
        { $Type: 'UI.ReferenceFacet', Label: 'General Info', Target: '@UI.FieldGroup#GeneralInfo' },
        { $Type: 'UI.ReferenceFacet', Label: 'Customer',     Target: '@UI.FieldGroup#Customer' },
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
	    {$Type: 'UI.DataField', Value: Itinerary_ID}
    ]
  },
  UI.FieldGroup#Customer: {
    Label: 'Customer',
    Data: [
      {$Type: 'UI.DataField', Value: Customer}, // customer ID from external service
      {$Type: 'UI.DataField', Value: EmailAddress},
      {$Type: 'UI.DataField', Value: NumberOfPassengers}
    ]
  },

);
