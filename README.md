## Exercises

### Exercise 01: Access SAP Cloud Platform account and clone code to Web IDE (10 minutes)
Branches: `master`
- Log in to cockpit w/ URL, user, password provided
- Find Web IDE Full-stack, open it
- Clone git repo w/ URL provided

### Exercise 02: Understand the data model and deplopy app to SAP Cloud Platform (25 minutes)
Branches: `master`
- Build (and deploy) _db_ module
  - Check logs
  - Open HDI container, browse data
  - Explore data model (no reuse of spaceflight, but all in one project). [Entity model picture](-exercises-/pictures/FlightModel.png) can be used.
- Run _srv_ module, open URL
  - Browse edmx (`$metadata`), and entities, e.g. _Airlines_, `$count`
  - Browse _srv_ folder
  - Explore data model (no reuse of spaceflight, but all in one project)
- Run _app_ module, open URL
  - Browse bookings, change, create

### Exercise 03: Connect an S/4HANA business service (business partner) (25 minutes)
Branches: `s4bp-start`, `s4bp-final`
- Import S/4 service
  - Start in Web IDE import wizard, but use upload edmx from [API hub](https://api.sap.com/api/API_BUSINESS_PARTNER/overview)
- Change model: add `Bookings.Customer`
- Change custom code: add S/4 calls
  - Destinations to S/4 already prepared
- Adjust UI to show business partner

### Exercise 04: How to build your own reuse model and consume it in your app (25 minutes)
Branches: `reuse-start`, `reuse-final`
- Add dependency to base model repo
- Remove redundant model code
- Add dependency to `@sap/cds/common` to add admin data


## Requirements

### For SAP TechEd 2018
SAP TechEd will provide you with a full environment to develop this sample application. The instructions below are only needed if you wish to run the application in your own account on SAP Cloud Platform.

### Development in SAP Cloud Platform Web IDE

SAP Web IDE Full-Stack access is needed. For more information, see [Open SAP Web IDE](https://help.sap.com/viewer/825270ffffe74d9f988a0f0066ad59f0/CF/en-US/51321a804b1a4935b0ab7255447f5f84.html).

Read the [getting started tutorial](https://help.sap.com/viewer//65de2977205c403bbc107264b8eccf4b/Cloud/en-US/5ec8c983a0bf43b4a13186fcf59015fc.html) to learn more about working with SAP Cloud Platform Web IDE.

A **HANA instance** is needed in your account, so that you can deploy the persistence assets.

Now clone your fork of this repository (*File -> Git -> Clone Repository*).

#### Develop, Build, Deploy

To build and deploy your application or modify it and redeploy, use any of the following options:

* Build and deploy the DB module by choosing *Build* from the context menu of the db folder.

* Build and deploy the Java service by choosing *Run -> Run as -> Java application* from the context menu of the srv folder. To test the service, click the URL displayed in the Run Console. Use the endpoint of the service *clouds.products.CatalogService* to call $metadata or CRUD requests.

* Test the UI by choosing *Run -> Run as -> SAP Fiori Launchpad Sandbox* from the context menu of the app folder. Click on the app tile to launch the application.

## Known Issues
None

## Support

This project is provided "as-is": there is no guarantee that raised issues will be answered or addressed in future releases.


## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This project is licensed under the Apache Software License, Version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.

# Content is obsolete

Now in https://github.com/SAP/cloud-sample-spaceflight-java

We will delete this repo soon.

