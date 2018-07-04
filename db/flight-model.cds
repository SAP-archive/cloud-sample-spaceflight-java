namespace teched.flight.trip;

entity Airports {
    key IATA                   : String(3)      not null;
        Name                   : String(100)    not null;
        City                   : String(30);
        Country                : String(50);
        Altitude               : Integer        default 0 not null;
        Latitude               : Decimal(12, 9) not null;
        Longitude              : Decimal(12, 9) not null;
        Departures             : Association to many EarthRoutes on Departures.StartingAirport=$self;
        Arrivals               : Association to many EarthRoutes on Arrivals.DestinationAirport=$self;
};

entity EarthRoutes {
    key ID                   : Integer   not null;
        Airline              : Association to Airlines;
        StartingAirport      : Association to Airports;
        DestinationAirport   : Association to Airports;
        Stops                : Integer   default 0;
        Equipment            : String(50);
};

entity Airlines {
    key ID        : String(2)  not null;
        Name      : String(50) not null;
        Country   : String(50) not null;
        Routes    : Association to many EarthRoutes on Routes.Airline=$self;
};

entity Bookings {
    key ID                 : UUID        @Core.Computed;
        Itinerary          : Association to Itineraries;
        CustomerName       : String(50)  not null;
        NumberOfPassengers : Integer     not null default 1;
        EmailAddress       : String(50)  not null;
        DateOfBooking      : DateTime    not null;
        DateOfTravel       : DateTime    not null;
        Cost               : Decimal(10, 2);
};

entity Itineraries {
    key ID        : Integer     not null;
        EarthLegs : {
            leg1  : Association to EarthRoutes;
            leg2  : Association to EarthRoutes;
            leg3  : Association to EarthRoutes;
            leg4  : Association to EarthRoutes;
            leg5  : Association to EarthRoutes;
        };
        Bookings  : Association to many Bookings on Bookings.Itinerary=$self;
};
