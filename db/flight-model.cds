namespace teched.flight.trip;

using { common.Named, common.Managed } from './common';

entity Airports : Named {
    key IATA                   : String(3);
        City                   : String(30);
        Country                : String(50);
        Altitude               : Integer        default 0 ;
        Latitude               : Decimal(12, 9) ;
        Longitude              : Decimal(12, 9) ;
        Departures             : Association to many EarthRoutes on Departures.StartingAirport=$self;
        Arrivals               : Association to many EarthRoutes on Arrivals.DestinationAirport=$self;
};

entity EarthRoutes {
    key ID                   : Integer;
        Airline              : Association to Airlines;
        StartingAirport      : Association to Airports;
        DestinationAirport   : Association to Airports;
        Stops                : Integer   default 0;
        Equipment            : String(50);
};

entity Airlines : Named {
    key IATA      : String(2);
        Country   : String(50) ;
        Routes    : Association to many EarthRoutes on Routes.Airline=$self;
};

abstract entity Itineraries : Named {
    key ID : Integer;
}

entity EarthItineraries : Itineraries {
    EarthLegs : {
        leg1  : Association to EarthRoutes;
        leg2  : Association to EarthRoutes;
        leg3  : Association to EarthRoutes;
        leg4  : Association to EarthRoutes;
        leg5  : Association to EarthRoutes;
    };
    Bookings  : Association to many Bookings on Bookings.EarthItinerary=$self;
};

entity Bookings : Managed {
    BookingNo          : String(33);  // yyyyMMddhhmmss-SP-[UUID]
    EarthItinerary     : Association to EarthItineraries;
    CustomerName       : String(50)  not null;
    NumberOfPassengers : Integer     default 1;
    EmailAddress       : String(50)  not null;
    DateOfBooking      : DateTime    not null;
    DateOfTravel       : DateTime    not null;
    Cost               : Decimal(10, 2) not null;
};
