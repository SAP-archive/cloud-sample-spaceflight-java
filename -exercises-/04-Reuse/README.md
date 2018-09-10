# Exercise 04: How to consume a reuse model in your app

## Estimated time

25 minutes

## Objective

In this exercise you'll learn how to reuse CDS model code from other applications.  Also you will see how our application benefits from generic runtime functionality for administrative fields, which are enabled through OData annotations.

# Exercise description

## 1. Preparation
1. For this exercise you have to switch to another code branch of the code you've cloned from Github. Click on the symbol on the right of the browser and click on `Pull` and after that on the `Fetch` symbol.

<p align="center"><img width="640" src="res/1.png" alt="New branch"> </p>

2. Checkout the `reuse-start` branch:
<p align="center"><img width="480" src="res/2.png" alt="Checkout reuse-start branch"> </p>


2. Once this has worked, you should see an information at the top right saying `Pull completed.` and `Fetch completed`

> You will find the final state of this exercise in branch `reuse-final`.


## 2. Add dependency to base model repo

1. Locate `package.json` at root level
<p align="center"><img width="320" src="res/3.png" alt="package.json"> </p>


2. Adjust `package.json` in the following two places
<p align="center"><img width="480" src="res/4.png" alt="package.json"> </p>
<p align="center"><img width="480" src="res/5.png" alt="package.json"> </p>

3. Let's see which files we get from the imported model

- Execute _Build CDS_ on the project
<p align="center"><img width="640" src="res/9.png" alt="Build cds"> </p>

- Find `node_modules/spaceflight-model` and see the model files
<p align="center"><img width="320" src="res/10.png" alt="Browse node_modules"> </p>

4. Remove redundant model code

- Delete files `common.cds`, `flight-model.cds`, and `space-model.cds`.  These files are now used from the reuse model.
<p align="center"><img width="480" src="res/7.png" alt="Delete files"> </p>


- Remove the first two lines of `index.cds`.  Comment in the last line.
<p align="center"><img width="860" src="res/6.png" alt="index.cds"> </p>

- Comment in the first line of `srv/booking-service.cds`.  Remove the rest of the lines.
<p align="center"><img width="640" src="res/8.png" alt="booking-service.cds"> </p>


5. Deploy to database
<p align="center"><img width="640" src="res/11.png" alt="index.cds"> </p>

6. Browse database
- Open database explorer:
<p align="center"><img width="640" src="res/12.png" alt="index.cds"> </p>


- See that we got 4 more columns in the `BOOKINGS` table:

<p align="center"><img width="640" src="res/13.png" alt="index.cds"> </p>
  These are admin data from `node_modules/@sap/cds/common.cds`, which we inherit through `node_modules/spaceflight-model/db/common.cds`.

- Restart application
<p align="center"><img width="640" src="res/14.png" alt="index.cds"> </p>

- Let's create a booking...
<p align="center"><img width="640" src="res/15.png" alt="index.cds"> </p>

<p align="center"><img width="640" src="res/16.png" alt="index.cds"> </p>
  ... and display it aftwards.

  _Booking date_ and _Booked by_ have been filled automatically.  This is possible since the underlying fields `Bookings.createdAt` and `Bookings.createdBy` are annotated such that the generic OData handlers know how to fill them (see `node_modules/@sap/cds/common.cds` for the annotations).
  > Normally with authentication enabled, the proper login user would be set for the `createdBy` field.  Without authentication, however, we just see Cloud Foundry's generic `vcap` user.
