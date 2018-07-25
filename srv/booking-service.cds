using teched.flight.trip as flight from '../db';
using BookingService from 'spaceflight-model/srv';


extend service BookingService with {
  entity Customers as projection on flight.Customers;
}

service LoadDataService {
  entity Customers as projection on flight.Customers;
  function loadCustomers() returns Integer; // number of customers fetched
}