namespace teched.space.trip;

using  common.Named from './common';
// The space flight model extends the underlying flight model
using teched.flight.trip as flight from './flight-model';

entity SpaceItineraries : flight.Itineraries {
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

extend flight.Bookings with {
    SpaceItinerary     : Association to SpaceItineraries;
}

entity AstronomicalBodies : Named {
    key ID          : Integer;
    SolarDistance   : Decimal(10, 8) ;
    SurfaceGravity  : Decimal(10, 6) ;
    Arrivals        : Association to many SpaceRoutes on Arrivals.DestinationPlanet=$self;
    Departures      : Association to many SpaceRoutes on Departures.StartingPlanet=$self;
    Spaceports      : Association to many Spaceports on Spaceports.OnPlanet=$self;
};

entity SpaceRoutes : Named {
    key ID                   : Integer;
    StartingPlanet           : Association to AstronomicalBodies;
    DestinationPlanet        : Association to AstronomicalBodies;
    StartingSpaceport        : Association to Spaceports;
    DestinationSpaceport     : Association to Spaceports;
    StartsFromOrbit          : Boolean    default false;
    LandsOnDestinationPlanet : Boolean    default false;
};

entity Spaceports : Named {
    key ID         : Integer;
        OnPlanet   : Association to AstronomicalBodies;
        Latitude   : Decimal(12, 9) ;
        Longitude  : Decimal(12, 9) ;
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

entity SpaceFlightCompanies :  Named {
    key ID            : Integer;
        OperatesFrom1 : Association to Spaceports;
        OperatesFrom2 : Association to Spaceports;
        OperatesFrom3 : Association to Spaceports;
};
