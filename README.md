# teched2018-cro2
TechEd 2018 Session Journey For Track CRO2

## Data model for cdsSpaceTrip

### Master Data Tables

CSV files have been created from which the database tables can be loaded.

***General Point on Representation of Latitude/Longitude***  
All coordinates are given in decimal notation rather than Degrees, Hours, Minutes, Seconds.

By convention, positive longitude is East and positive latitude is North.  Therefore, longitude coordinate values should range between ±180.0˚ and latitude values should range between ±90.0˚


#### airlines.csv

Holds air line information keyed on the 2-character IATA code (E.G. "LH" = Lufthansa, "BA" = British Airways), followed by the name of the airline company and their country of origin.

E.G. The entry for British Airways is:

`BA,British Airways,United Kingdom`


#### airports.csv

Airport information is keyed on the 3-character IATA code.  Each airport is described by its name, city and country.

E.G. The entry for London's Heathrow Airport is the following:

`LHR,London Heathrow Airport,London,United Kingdom,83,51.4706,-0.461941`

The last three numeric fields for altitude (in feet), latitude and longitude

#### earthroutes.csv
The routes flown by terrestrial airline companies are stored in this table.  Each route is uniquely identified with an integer (the route id) and holds the airline id, the IATA code of the starting airport and the IATA code of the destination airport.  The last two columns hold the number of stops and a space separated text field containing the codes of the aircraft used on that route.

E.G.  Route number 10338 is the following:

`10338,BA,AMS,LHR,0,320 767 319 321`

This entry indicates that British Airways operates a direct flight from Amsterdam to London Heathrow.  The aircraft that fly this route are the Boeing 767 and the Airbus A319, A320, and A321.

#### astrobodies.csv

A simple table holding details of the astronomical bodies in our solar system - some of which might be targets for space tourism.

Each astronomical body is assigned a numeric id, to describe its name, average distance from the sun (in astronomical units or AUs) and the strength of the force of gravity at the surface of that body (as a proportion of Earth's gravity).

E.G. the entry for Mars is:

`5,Mars,1.524,0.376`

This indicates that for astronomical body 5 is called "Mars", orbits at an average distance to the Sun of 1.524 AUs and has a surface gravity of only 0.376 times that experienced on Earth.

#### spaceports.csv

Instead of mixing rocket launching sites in with airport data, there is a separate table holding Spaceport information.  This consists of a list of the worldwide sites capable of launching a vehicle into a lunar orbit or higher.

To date, there are only 9 such sites worldwide: 1 in China, 1 in India, 2 in Japan, 1 in Russia and 4 in the United States.

To allow for future (fictitious) expansion of this data to Spaceports on the Moon or Mars, this table also includes the "planet id" of the Spaceport.  This is simply an integer with a foreign key relationship to the AstroBodyId field in the AstronomicalBodies table.

3, non-terrestrial Spaceports have been added; 1 on the Moon at Tranquility Base (the Apollo 11 landing site) and 2 on Mars (two proposed sites for the Mars 2020 mission)

#### spaceflightcompanies.csv

Companies that either currently operate, or are planning to operate, space vehicles large enough to enter lunar orbit or higher are listed here.

This table simply assigns an integer id to the name, followed by up to three Spaceport ids from which that company operates.

#### spaceroutes.csv

This data is somewhat more complicated than that held in the `EarthRoutes` table.  This is because a space journey is divided into distinct stages that do not necessarily start from or end on the surface of a planet.

Let's assume you want to land on the Moon.  This journey is divided into the following stages:

1. Launch into low earth orbit (LEO), then obit the Earth a couple of times.
1. Fire the motors again to enter a transfer orbit (known as a trans-lunar injection, or TLI)
1. Since we want to land on the Moon, then your TLI orbit causes you to enter a low lunar orbit
1. Finally, you descend to the lunar surface

The return flight is the same idea in reverse:

1. Launch into low lunar orbit
1. Burn the motors to enter a transfer orbit back to Earth.
1. Enter low earth orbit
1. Re-enter Earth's atmosphere and descend to the surface

Alternatively, a space tourism flight will not want to land on the destination planet; therefore, you would plan a "free return" orbit.  For Mars, you would:

1. Launch into low earth orbit (LEO), then obit the Earth a couple of times.
1. Fire the motors again to enter start a free-return trans-lunar injection.  This trajectory causes you to just miss entering low lunar orbit.  Now you will swing around the Moon and return to Earth without needing to fire the motors (hence the name, since you can return to Earth for "free")
1. Enter LEO (Low Earth Orbit)
1. Re-enter Earth's atmosphere and descend to the surface



## Using the Data Model

In order to book a space trip, you must first build the itinerary.

Each itinerary is composed of two parts:

1. Getting the passengers from their home location to the launch site.
1. Once at the launch site, they travel between astronomical bodies always returning to Earth.

Once you have created the itinerary, you can then created the booking for that itinerary.

### Getting to the Launch Site

This is simply a sequence of between one and five regular aeroplane rides - no LEO travel (Low Earth Orbit) or fancy stuff like that - just cruising at 30,000 ft.

At this point, you will need to pick at least one, but no more than five, `EarthRoute` entries to get the passengers from their home city to the launch site used by their chosen Space Flight Company.

These entries will go into fields `EarthLegs1`, `EarthLegs2`, `EarthLegs3` etc of a new entry for table `Itineraries`.

### Going to Space

Once at the launch site, the remainder of the itinerary is built by choosing between one and ten entries from the `SpaceRoutes` table.  These entries then determine where the passengers go whilst in space, and whether or not they land on the destination planet.

Space travel is more complex than air travel, so there are more legs in a space flight journey than there are in an air travel journey.

The entries in the `SpaceRoutes` section of the `Itinerary` table will vary depending on whether you want to land on the destination planet or use a free-return orbit and swing back to Earth again.

Below are the `SpaceRouteId`s needed to complete some example space flights:

***Itineraries for Free Return Journeys***  
Earth to Mars  
`1    LEO`  
`9    Free Return Transfer Orbit (Earth to Mars)`  
`1    LEO`  
`10    Earth Re-entry`  

Earth to Moon  
`1    LEO`  
`8    Free Return Transfer Orbit (Earth to Moon)`  
`1    LEO`  
`10    Earth Re-entry`  

***Itineraries for Landing on Destination Planet***  
Earth to Mars  
`1    LEO`  
`5    Transfer Orbit (Earth to Mars)`  
`3    Low Martian Orbit`  
`12   Martian Descent`  

Earth to Moon  
`1    LEO`  
`4    Transfer Orbit (Earth to Moon)`  
`2    Low Lunar Orbit`  
`11   Lunar Descent`  

Mars to Earth  
`3    Low Martian Orbit`  
`6    Transfer Orbit (Mars to Earth)`  
`1    LEO`  
`10    Earth Re-entry`  

Moon to Earth  
`2    Low Lunar Orbit`  
`7    Transfer Orbit (Moon to Earth)`  
`1    LEO`  
`10    Earth Re-entry`  

