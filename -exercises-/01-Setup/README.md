# Exercise 01: Accessing the SAP Cloud Platform Account and Cloning Sample From Github

## Estimated time

10 minutes

## Objective

In this exercise you'll learn how to clone the Git repository that contains the sample project of this tutorial into the WebIDE of the SAP Cloud Platform

 Exercise description

## 1. Access the WebIDE

1. In a first step you need to access the WebIDE of your account. For the hands-on session **CNA376** at SAP TechEd 2018 use the link provided to you by the session instructors along with the corresponding credentials.
<p align="center"><img width="420" src="res/pic100.png" alt="Log on screen"> </p>

2. In case you are asked to upgrade your account pleae set a tick at the field `I acknowledge...` and provide your First Name (e.g. CNA376) and your Last Name "xxx".

<p align="center"><img width="420" src="res/pic101.png" alt="Upgrade account"> </p>

3. The WebIDE should open up and shows your workspace. The workspace should be empty.

<p align="center"><img width="640" src="res/pic102.png" alt="WebIDE workspace"> </p>

## 2. Setup workspace settings

1. Click on the preferences icon on the left and click on `Features` in the `Workspace Preferences`. Next, switch `ON` the `SAP HANA Database Devlopment Tools`. Finally click on the `Save` button at the bottom to enable the tools in your workspace.

<p align="center"><img width="640" src="res/pic201.png" alt="WebIDE workspace"> </p>

> In the pop-up please click on **Refresh**, so that the Web IDE can be re-started with the new settings.

<p align="center"><img width="320" src="res/pic202.png" alt="Refresh WebIDE workspace"> </p>

3. In a final step click on `Cloud Foundry` in the `Workspace Preferences` In the field for the `API endpoint` select the value `https://api.cf.eu10.hana.ondemand.com` If you do so, the values for `Organization` and `Space` will be set automatically to `TechEd2018_CNA376-TechEd2018` and `Test` Please click on the `Save` button.

> Please do NOT click on `Reinstall Builder`!!

<p align="center"><img width="640" src="res/pic203.png" alt="Enter Cloud Foundry API endpoint"> </p>

<p align="center"><img width="320" src="res/pic204.png" alt="Confirmation about stored preferences"> </p>


## 3. Clone the code

1. Switch to the `Development` view in your workspace.
<p align="center"><img width="320" src="res/pic301.png" alt="Switch to development view"> </p>


2. Now, right click on the Workspace text in the WebIDE and select `Git > Clone Repository `

<p align="center"><img width="640" src="res/pic302.png" alt="Git Clone"> </p>

3. In the URL field please enter the URL `http://github.com/SAP/cloud-samples-spaceflight-java` and click on the `Clone` button.

<p align="center"><img width="320" src="res/pic303.png" alt="Git URL"> </p>

4. You should see now the code that was cloned into your WebIDE workspace. 

<p align="center"><img width="640" src="res/pic304.png" alt="Git URL"> </p>

> This workspace has now a local copy of the cloned code in the WebIDE.

5. Finally you can click on the project `cloud-samples-spaceflight-java` and look into the pre-filled folders.