# Exercise 02: Understand the data model and deplopy app to SAP Cloud Platform

## Estimated time

25 minutes

## Objective

In this exercise you'll have a look into the data model of the application and you'll deploy it to your SAP Cloud Platform account

 Exercise description

## 1. Build the data model and deploy it to your HANA instance

1. Click on the folder `db` of your project, right-click on it and click on `Build > Build`

<p align="center"><img width="480" src="res/pic101.png" alt="Build the database"> </p>

> During this step the data model is being transformed into the respective HANA artifacts and a **HDI Container** is being created.

2. While the HANA artifacts are being created open the `db` folder, double-click on the file `flight-model.cds` and have a look into the definition of the data model. 
<p align="center"><img width="860" src="res/pic102.png" alt="The flight model"> </p>

3. Once the HANA artifacts are created, you should see in the screen at the bottom (the console) a respective message like `Build of /cloud-sample-spaceflight-java/db completed successfully`

<p align="center"><img width="640" src="res/pic103.png" alt="Console screen with console output"> </p>

4. Now that the HDI container has been created, we can look into it. Right-click again on the `db` folder and select `Open HDI container`.

<p align="center"><img width="640" src="res/pic104.png" alt="Open HDI container"> </p>

5. When asked whether to add any database, simply click `No`, as the database connection will be added automatically in this case.

<p align="center"><img width="480" src="res/pic105.png" alt="Database Explorer message"> </p>



6. Click on the `Tables` icon on the left, select the table 'TECHED_FLIGHT_TRIP_BOOKINGS` and you'll be presented at the right, with the schema definition.

<p align="center"><img width="860" src="res/pic110.png" alt="See data schema"> </p>

7. If you want to see the pre-filled data, click on the `Open Data` button on the top right.

<p align="center"><img width="480" src="res/pic111.png" alt="Click on Open Data button"> </p>
<p align="center"><img width="860" src="res/pic112.png" alt="Data view"> </p>

> The data you see here is maintained in the resource folder `db > src > csv`. 
<p align="center"><img width="860" src="res/pic113.png" alt="CSV files in db folder"> </p>

## 2. Run the OData service and access it

1. Go back to the `Development` view of your workspace and click on the `srv` folder of your project. You'll notice that you can click on the **play** icon under the menu. Please click the button to run the service layer of the app. 

<p align="center"><img width="640" src="res/pic201.png" alt="Press play"> </p>

> In the console you can watch how the service is being build any deployed. Once it is ready, a link is provided. Click on that link to open the URL of the OData endpoints.
<p align="center"><img width="860" src="res/pic202.png" alt="Application being build"> </p>

2. The OData endpoints are displayed. Click on the link for the `BookingService`.

<p align="center"><img width="640" src="res/pic203.png" alt="API endpoints"> </p>

3. You can now see the entities of the booking service

<p align="center"><img width="640" src="res/pic204.png" alt="API endpoints"> </p>


> So far the database and the service layer are running. In the next step we'll deploy the UI.

## 3. Run the app module

1. Click on the `app` folder of your project. Click again on the **play** icon under the menu to build the UI of the application.

<p align="center"><img width="640" src="res/pic301.png" alt="Press play"> </p>


2. Select the file `flpSandbox.html` and click on the `OK` button.

<p align="center"><img width="640" src="res/pic302.png" alt="Select app"> </p>

3. If you get this pop-up provide your email address the account password.

<p align="center"><img width="640" src="res/pic303.png" alt="Select app"> </p>

4. Once the app is created it will open-up automatically. Click on the tile `app`

<p align="center"><img width="640" src="res/pic304.png" alt="Select app"> </p>

5. Click on the `Go` button to fetch the data from the database.

<p align="center"><img width="640" src="res/pic305.png" alt="Select app"> </p>

6. You can get to the details for each booking, by clicking on one of them.
<p align="center"><img width="640" src="res/pic306.png" alt="Select app"> </p>
