# Exercise 02: Understand the data model and deploy app to SAP Cloud Platform

## Estimated time

25 minutes

## Objective

In this exercise you will have a look into the data model of the application and you will deploy it to your SAP Cloud Platform account.

## Exercise description

### 1. Build the data model and deploy it to SAP HANA

1.1. Click on the folder `db` of your project and from the context menu select `Build` > `Build`.

   <p align="center"><img width="480" src="res/pic101.png" alt="Build the database"> </p>

   > During this step, the data model is compiled into the respective `hdbcds` artifacts, which are then deployed to an HDI Container (a database schema).  In Web IDE's console view you can watch the progress of the deployment operation.

1.2. Open the `db` folder, double-click on the file `flight-model.cds` and have a look into the definition of the data model.
   <p align="center"><img width="860" src="res/pic102.png" alt="The flight model"> </p>

   > Tip: To help you find files easier in the tree, enable the `Link Workspace to Editor` setting.  Everytime you switch to another editor, this will select the file in the file tree.
       <p align="center"><img width="320" src="res/pic114.png" alt="Link with editor"> </p>

1.3. Once the HANA artifacts are created, you should see a success message in the console view at the bottom.

   <p align="center"><img width="640" src="res/pic103.png" alt="Console with deployment output"> </p>

<!-- 1.4. Let's take a look into what was deployed. Right-click again on the `db` folder and select `Open HDI container`.  This will open up the SAP HANA database explorer.

   <p align="center"><img width="640" src="res/pic104.png" alt="Open HDI container"> </p>

   In case you are asked whether to add any database, simply click `No`, as the database connection will be added automatically.

   <p align="center"><img width="480" src="res/pic105.png" alt="Database explorer message"> </p>

1.5. Click on the `Tables` icon on the left, select table `TECHED_FLIGHT_TRIP_BOOKINGS`, which opens the table editor.

   <p align="center"><img width="860" src="res/pic110.png" alt="See table definition"> </p>

1.6. If you want to see the table data, click on the `Open Data` button on the top right.

   <p align="center"><img width="480" src="res/pic111.png" alt="Click on Open Data button"> </p>
   <p align="center"><img width="860" src="res/pic112.png" alt="Data view"> </p>

   > The data you see here is maintained in the resource folder `db > src > csv` and was deployed along with the table definitions.
       <p align="center"><img width="860" src="res/pic113.png" alt="CSV files in db folder"> </p>
 -->

### 2. Run the OData service

2.1. Go back to the `Development` perspective of your workspace and select the `srv` folder of your project.  Click on the green **Run** icon in the main toolbar to run the app.

   <p align="center"><img width="480" src="res/pic201.png" alt="Press Run"> </p>

2.2. In the console you can watch how the service is being build any deployed. Once it is ready, a link is provided. Click on that link to the OData endpoints in the browser.

   <p align="center"><img width="860" src="res/pic202.png" alt="Application being deployed"> </p>

2.3. The OData endpoints are displayed. Click on the link for the `BookingService`.

   <p align="center"><img width="480" src="res/pic203.png" alt="API endpoints"> </p>

2.4. You can now see the entities of the booking service...

   <p align="center"><img width="640" src="res/pic204.png" alt="Bookingservice entities"> </p>

   ... and all bookings, by navigating to the `BookingService/Bookings` URL.
   <p align="center"><img width="640" src="res/pic205.png" alt="Bookings entities"> </p>

So far the database and the service layer are running. In the next step we will deploy the UI.

### 3. Run the UI module

3.1. Click on the `app` folder of your project. Click again on the **Run** icon in the main toolbar.

   <p align="center"><img width="480" src="res/pic301.png" alt="Press Run"> </p>


3.2. On the first run, a dialog may be shown asking you to log on to the Neo environment.  Again provide the email address and the password for your user.

   <p align="center"><img width="480" src="res/pic303.png" alt="Log on to create destination"> </p>

   > This double login will become superfluous in future versions of Web IDE.

3.3. Once the app is created, a browser window will be opened.  There, click on the first tile named `app`.

   <p align="center"><img width="480" src="res/pic304.png" alt="Select the tile named 'app'"> </p>

3.4. In the `Bookings` screen, click on the `Go` button to fetch the bookings from the database.

   <p align="center"><img width="640" src="res/pic305.png" alt="Fetch bookings through the 'Go' button"> </p>

3.5. You can get to the details for each booking, by clicking on one of them.

   <p align="center"><img width="640" src="res/pic306.png" alt="Inspect single booking"> </p>
