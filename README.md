## Description
This repository contains the sample code for a 'space travel' application.

### Scenario
You are working in the IT department of the space travel agency SPICY (SPace Itineraries CompanY) and are asked by management to develop the best-of-breed enterprise-grade booking app.
Timeline is tight and the legal requirements of 20 planets need to be considered.  You start with the SAP Cloud Platform that will bring you where no app developer has gone before.

## Exercises

See the [exercises folder](https://github.com/SAP/cloud-sample-spaceflight-java/tree/master/-exercises-).

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
