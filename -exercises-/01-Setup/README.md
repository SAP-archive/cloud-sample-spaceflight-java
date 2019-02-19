# Exercise 01: Access the SAP Cloud Platform account and clone sample code

## Estimated time

10 minutes

## Objective

In this exercise you will learn how to clone the Git repository that contains the sample project of this tutorial into the Web IDE of the SAP Cloud Platform.

## Prequisites

Make sure to have the following:

1. An SAP Cloud Platform (Cloud Foundry) account containing at least the services:
   - SAP HANA Database (Standard or Enterprise)
   - SAP HANA Schemas & HDI Containers (hdi-shared)

2. An SAP Cloud Platform (Neo) account that provides access to at least SAP Web IDE.

You may want use a **free trial account** for SAP Cloud Platform.  Follow this [tutorial to create a trial account](https://developers.sap.com/tutorials/hcp-create-trial-account.html).

## Notes
For all exercises please make sure to use **Google Chrome**.

## Exercise description

### 1. Log on to SAP Web IDE

- If your are unsure where to find the Web IDE URL, follow this [tutorial](https://developers.sap.com/tutorials/sapui5-webide-open-webide.html).
- Web IDE opens up and shows your workspace. The workspace is empty if you use it for the first time.

   <p align="center"><img width="480" src="res/pic102.png" alt="Web IDE workspace"> </p>

### 2. Setup workspace settings

2.1. Click on `Cloud Foundry` in the `Workspace Preferences`

   - In the field for the `API endpoint` select the the URL that matches your Cloud Foundry account (usually the first URL).  If you are asked to logon, use your user/password.

   - Same for the values for `Organization` and `Space`: chose the values matching to your account.

   - Should the be an error on the page saying that the builder is outed, press the `Reinstall Builder` button.

   - Click on the **Save** button, even if you haven't changed anything.

   <p align="center"><img width="480" src="res/pic203.png" alt="Enter Cloud Foundry API endpoint"> </p>

   You will get a confirmation message:
   <p align="center"><img width="320" src="res/pic204.png" alt="Confirmation about stored preferences"> </p>

2.2. Click on the preferences icon on the left and select `Extensions`. Next, enter `HANA Database Dev` in the search box and switch `ON` the `SAP HANA Database Devlopment Tools`. Finally click on the `Save` button at the bottom to enable the tools in your workspace.

   <p align="center"><img width="640" src="res/pic201.png" alt="Web IDE workspace"> </p>

   In the pop-up click on **Refresh**, so that the Web IDE can be re-started with the new settings.

   <p align="center"><img width="320" src="res/pic202.png" alt="Refresh Web IDE workspace"> </p>


### 3. Clone the code

3.1. Switch to the `Development` view in your workspace.
   <p align="center"><img width="480" src="res/pic301.png" alt="Switch to development view"> </p>


3.2. Now, right click on the Workspace text in the Web IDE and select `Git > Clone Repository `

   <p align="center"><img width="640" src="res/pic302.png" alt="Git Clone"> </p>

3.3. In the URL field enter the URL `https://github.com/SAP/cloud-sample-spaceflight-java` and click on the `Clone` button.
   <p align="center"><img width="320" src="res/pic303.png" alt="Git URL"> </p>

4. After a short while, you will see the code that was cloned into your Web IDE workspace.

   <p align="center"><img width="640" src="res/pic304.png" alt="Project cloned"> </p>

   > This workspace has now a local copy of the cloned code in the Web IDE.  In the next exercise we will take a look into this project.


## Next

Continue with [exercise 2](../02-Deploy).
