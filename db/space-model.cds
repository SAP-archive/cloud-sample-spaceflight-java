// *********************************************************************************************************************
//                                                S P A C E   M O D E L
//
// Uses the Flight data model as its base and then extends it to represent journeys made in space
//
// The key difference between traveling on earth and travelling in space, is that on earth, for short journeys, you
// think in straight lines, and for longer journeys, you think in "Great Circles".
// However, when travelling in space, you must think in ellipses. Also, due to the weight and cost of rocket fuel, you
// will always choose the most energy efficient path between two points.  This path will be an ellipse that approximates
// a Hohmann Transfer Orbit.
// *********************************************************************************************************************
namespace teched.space.trip;

// Reference the base data model and any abstract types
using teched.flight.trip as flight from './flight-model';

// ---------------------------------------------------------------------------------------------------------------------
// AstronomicalBodies
//
// Any planet or moon that could act as a travel destination.  This data should be treated a read-only
//
// SolarDistance is measured in astronomical units (AUs) where the distance from the Earth to the Sun = 1.0
// SurfaceGravity is that fraction of Earth's gravity experienced on the surface of this body
// ---------------------------------------------------------------------------------------------------------------------
entity AstronomicalBodies {
  key ID             : Integer;
      Name           : String(100) @title: "Astronomical Body";
      SolarDistance  : Decimal(10, 8);
      SurfaceGravity : Decimal(10, 6);
      Arrivals       : Association to many SpaceRoutes on Arrivals.DestinationPlanet=$self;
      Departures     : Association to many SpaceRoutes on Departures.StartingPlanet=$self;
      Spaceports     : Association to many Spaceports  on Spaceports.OnPlanet=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// Spaceports
//
// This entity performs the same role as "Airports" in the base data model, but is used exclusively to represent launch
// sites for space flights.  These launch sites are not necessarily located on Earth.
//
// To allow for future (fictitious) expansion of this data to include Spaceports on other astronomical bodies, this
// entity also includes the field "OnPlanet" which holds the ID of the Astronomical Body on which the Spaceport is
// located.  3, non-terrestrial Spaceports have been added; 1 on the Moon at Tranquility Base (the Apollo 11 landing
// site) and 2 on Mars (two proposed sites for the Mars 2020 mission)
// ---------------------------------------------------------------------------------------------------------------------
entity Spaceports {
  key ID         : Integer;
      Name       : String(100) @title: "Spaceport";
      OnPlanet   : Association to AstronomicalBodies;
      Latitude   : Decimal(12, 9) ;
      Longitude  : Decimal(12, 9) ;
      OperatedBy : Association to many SpaceFlightCompanies
        on OperatedBy.OperatesFrom1=$self
        or OperatedBy.OperatesFrom2=$self
        or OperatedBy.OperatesFrom3=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// SpaceFlightCompanies
//
// This entity performs the same role as "Airlines" in the base data model, but is used exclusively to represent
// companies operating launch vehicles suitable for Lunar space travel or beyond.
//
// A space flight company can operate from up to three different spaceports
// ---------------------------------------------------------------------------------------------------------------------
entity SpaceFlightCompanies {
  key ID            : Integer;
      Name          : String(100) @title: "Space Flight Company";
      OperatesFrom1 : Association to Spaceports;
      OperatesFrom2 : Association to Spaceports;
      OperatesFrom3 : Association to Spaceports;
};

// ---------------------------------------------------------------------------------------------------------------------
// SpaceRoutes
//
// This entity serves the same purpose EarthRoutes in the base model; however, travelling through space is not a simple
// matter of taking off from one planet and landing on another.  Interplanetary flight is divided into distinct stages,
// and not all of these stages start from, or end on the surface of a planet.
//
// By contrast to the Earthroutes entity, each route in this entity uses an aribrary integer id as its key.
//
// E.G. In order to travel from the Earth to the Moon, we must first decide whether or not we are going to land on the
// target planet.  For instance, if we decide to follow the flight path of the Apollo 8 mission, then we will orbit, but
// not land on, the Moon.  The journey will then be comprised of the following stages:
//
// 1) Take-off
//    This launches the vehicle from the surface of the Earth into Low Earth Orbit (LEO)
//
// 2) Free Return Lunar Transfer Orbit
//    Because we are not going to land on the Moon, the motors are fired to inject the vehicle into an elliptical path
//    that just avoids it being captured by the Moon's gravitational field.  Instead, it uses the Moon's gravity to
//    slingshot the vehicle back to Earth.  Once the vehicle is injected into this type of orbit, it can return to Earth
//    without needing to fire its motors again - hence the term "Free Return"
//
// 3) Re-enter Low Earth Orbit (LEO)
//    The motors are fired to decelerate the vehicle and allow it to be captured by Earth's gravity, re-entering LEO
//
// 4) Final descent to the surface
//    The motors are fired for the last time to bring the vehicle out of LEO in order to descend to the surface
//
// Each one of these stages of the journey is represented as separate route in the SpaceRoutes entity
//
// If however, we want to follow the Apollo 11 flight path and actually land on the surface of the Moon, then the
// journey will be comprised of the following slightly different stages:
//
// 1) Take-off
//    Launches the vehicle into LEO
//
// 2) Lunar Injection Orbit
//    The motors are fired to inject the vehicle into an elliptical path that allows it to be captured by the Moon's
//    gravitational field.
//
// 3) Enter Low Lunar Orbit
//    The motors are fired to decelerate the vehicle and allow it to be captured by the Moon's gravity, thus entering
//    Low Lunar Orbit
//
// 4) Final descent to the surface
//    The motors are fired to bring the vehicle out of Low Lunar Orbit in order to descend to the surface
//
// The homeward journey will be the reverse of the above.
//
// As can be seen from the examples above, a SpaceRoute is not required to start or end on the surface of a planet.
// Therefore, it is valid for the fields StartingSpaceport, DestinationSpaceport and StartingPlanet to remain null;
// however, the DestinationPlanet field shoudl always be populated.
// ---------------------------------------------------------------------------------------------------------------------
entity SpaceRoutes {
  key ID                       : Integer;
      Name                     : String(100) @title: "Space Route";
      StartingPlanet           : Association to AstronomicalBodies;
      DestinationPlanet        : Association to AstronomicalBodies;
      StartingSpaceport        : Association to Spaceports;
      DestinationSpaceport     : Association to Spaceports;
      StartsFromOrbit          : Boolean    default false;
      LandsOnDestinationPlanet : Boolean    default false;
};


// ---------------------------------------------------------------------------------------------------------------------
// Extension to Itineraries
//
// This extension is used to represent the legs (or stages) of a journey in space.  Due to the extra complexity of
// space travel (compared to travelling on earth), each space journey can be comprised of up to 9 legs.
// ---------------------------------------------------------------------------------------------------------------------
extend flight.Itineraries {
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
