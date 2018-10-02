# Exercise 01: Access the SAP Cloud Platform account and clone sample code

## Estimated time

10 minutes

## Objective

In this exercise you will learn how to clone the Git repository that contains the sample project of this tutorial into the Web IDE of the SAP Cloud Platform.

## Exercise description

### 1. Log on to Web IDE

1.1. In a first step you need to access the Web IDE of your account. For the hands-on session **CNA376** at SAP TechEd 2018 use the [following link](https://webidecp-jgxcdnv3bs.dispatcher.hana.ondemand.com/) and the credentials from the session intructors.  Select the `Remember me` checkbox.
   <p align="center"><img width="420" src="res/pic100.png" alt="Log on screen"> </p>

1.2. In case you are asked to upgrade your account, set the tick at the field `I acknowledge...` and provide your First Name (e.g. CNA376) and your Last Name "xxx".

   <p align="center"><img width="420" src="res/pic101.png" alt="Upgrade account"> </p>

1.3. The Web IDE opens up and shows your workspace. The workspace is empty if you use it for the first time.

   <p align="center"><img width="640" src="res/pic102.png" alt="Web IDE workspace"> </p>

### 2. Setup workspace settings

2.1. Click on `Cloud Foundry` in the `Workspace Preferences`. In the field for the `API endpoint` select the first item `https://api.cf.eu10.hana.ondemand.com`. If you are asked to logon, use your user/password for this exercise.

   The values for `Organization` and `Space` will be set automatically to `TechEd2018_CNA376-TechEd2018` and the space your user is assigned to.

   **Do NOT** click the `Reinstall Builder` button as this would affect users working within the same Cloud Foundry space.

   <p align="center"><img width="640" src="res/pic203.png" alt="Enter Cloud Foundry API endpoint"> </p>

   **Click on the `Save` button**, even if you haven't changed anything.

   You will get a confirmation message:
   <p align="center"><img width="320" src="res/pic204.png" alt="Confirmation about stored preferences"> </p>

2.2. Click on the preferences icon on the left and select `Features`. Next, enter `HANA Database Dev` in the search box and switch `ON` the `SAP HANA Database Devlopment Tools`. Finally click on the `Save` button at the bottom to enable the tools in your workspace.

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