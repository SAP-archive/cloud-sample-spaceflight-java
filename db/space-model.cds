namespace teched.space.trip;

// The space flight model extends the underlying flight model
using teched.flight.trip.Itineraries from './flight-model';
extend entity Itineraries with {
    SpaceLegs : {
        leg1  : Association to SpaceRoutes;
        leg2  : Association to SpaceRoutes;
        leg3  : Association to SpaceRoutes;
        leg4  : Association to SpaceRoutes;
        leg5  : Association to SpaceRoutes;
        leg6  : Association to SpaceRoutes;
        leg7  : Association to SpaceRoutes;
        leg8  : Association to SpaceRoutes;
        leg9  : Association to SpaceRoutes;
    };
};

entity AstronomicalBodies {
    key ID              : Integer        not null;
        Name            : String(20)     not null;
        SolarDistance   : Decimal(10, 8) not null;
        SurfaceGravity  : Decimal(10, 6) not null;
        Arrivals        : Association to many SpaceRoutes on Arrivals.DestinationPlanet=$self;
        Departures      : Association to many SpaceRoutes on Departures.StartingPlanet=$self;
        Spaceports      : Association to many Spaceports on Spaceports.OnPlanet=$self;
};

entity SpaceRoutes {
    key ID                       : Integer    not null;
        Name                     : String(50) not null;
        StartingPlanet           : Association to AstronomicalBodies;
        DestinationPlanet        : Association to AstronomicalBodies;
        StartingSpaceport        : Association to Spaceports;
        DestinationSpaceport     : Association to Spaceports;
        StartsFromOrbit          : Boolean    default false;
        LandsOnDestinationPlanet : Boolean    default false;
};

entity Spaceports {
    key ID         : Integer        not null;
        Name       : String(50)     not null;
        OnPlanet   : Association to AstronomicalBodies;
        Latitude   : Decimal(12, 9) not null;
        Longitude  : Decimal(12, 9) not null;
        // Didn't understand the meaning of that one:
        // ToStartingSpaceportId : association[1, 1..1] to cdsSpaceTrip.SpaceRoutes { StartingSpaceportId };
        // > would translate to something like the below, which seems weird
        // StartingSpaceport     : Association to SpaceRoutes on StartingSpaceport.StartingSpaceport=$self;
        OperatedBy : Association to many SpaceFlightCompanies on
        // (
            OperatedBy.OperatesFrom1=$self or
            OperatedBy.OperatesFrom2=$self or
            OperatedBy.OperatesFrom3=$self
        // )
        ;
};

entity SpaceFlightCompanies {
    key ID            : Integer    not null;
        name          : String(50) not null;
        OperatesFrom1 : Association to Spaceports;
        OperatesFrom2 : Association to Spaceports;
        OperatesFrom3 : Association to Spaceports;
};
