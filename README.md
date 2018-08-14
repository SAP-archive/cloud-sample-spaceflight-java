# Scenario
You are working in the IT department of the space travel agency SPICY (SPace Itenaries CompanY) and are asked by management to develop the best-of-breed enterprise-grade booking app.
Timeline is tight and the legal requirements of 20 planets need to be considered.  You start with the SAP Cloud Platform that will bring you where no app developer has gone before.

## Setup
- Subaccounts: [Neo](https://account.hana.ondemand.com/cockpit#/globalaccount/8fd39023-a237-4d71-9b6a-ed9d1719d275/neosubaccount/14adb57e-f61c-4c24-8f26-097bc53a3d7c/services), [Cloud Foundry](https://account.hana.ondemand.com/cockpit#/globalaccount/8fd39023-a237-4d71-9b6a-ed9d1719d275/subaccount/309ec1a5-dd47-4e3b-88a7-56e88a8a6e8a/details)
- [Web IDE](https://webidecp-jgxcdnv3bs.dispatcher.hana.ondemand.com/)

### Preview
Deployed on [https://cdsteched2018-cna376-spacetravel-app.cfapps.sap.hana.ondemand.com](https://cdsteched2018-cna376-spacetravel-app.cfapps.sap.hana.ondemand.com/app/test/flpSandbox.html#Bookings-display).

# Exercises

## Exercise 01: Access SAP Cloud Platform account and clone code to Web IDE (10 minutes)
Branches: `master`
- Log in to cockpit w/ URL, user, password provided
- Find Web IDE Full-stack, open it
- Clone git repo w/ URL provided

## Exercise 02: Understand the data model and deplopy app to SAP Cloud Platform (25 minutes)
Branches: `master`
- Build (and deploy) _db_ module
  - Check logs
  - Open HDI container, browse data
  - Explore data model (no reuse of spaceflight, but all in one project)
- Run _srv_ module, open URL
  - Browse edmx (`$metadata`), and entities, e.g. _Airlines_, `$count`
  - Browse _srv_ folder
  - Explore data model (no reuse of spaceflight, but all in one project)
- Run _app_ module, open URL
  - Browse bookings, change, create

## Exercise 03: Connect an S/4HANA business service (business partner) (25 minutes)
Branches: `s4bp-start`, `s4bp-final`
- Import S/4 service
  - Start in Web IDE import wizard, but use upload edmx from [API hub](https://api.sap.com/api/API_BUSINESS_PARTNER/overview)
- Change model: add `Bookings.Customer`
- Change custom code: add S/4 calls
  - Destinations to S/4 already prepared
- Adjust UI to show business partner

## Exercise 04: How to build your own reuse model and consume it in your app (25 minutes)
Branches: `reuse-start`, `reuse-final`
- Add dependency to base model repo
- Remove redundant model code
- Add dependency to `@sap/cds/common` to add admin data


## Exercise 08: Bonus 1 - I18N
- Extract some texts
- Deploy
- Change browser language, see effect

## Exersice 07: Bonus 2 - Authentication
- UAA binding
- Effect: logon needed

## Exercise  Bonus 3 - Switch destination


## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This project is licensed under the Apache Software License, Version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
