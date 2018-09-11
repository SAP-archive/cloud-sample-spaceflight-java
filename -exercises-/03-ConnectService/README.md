# Exercise 03: Connect an S/4HANA service (business partner)

## Estimated time

25 minutes

## Objective

In this exercise you'll learn how to add a remote service to your app which fetches customer data from an S/4 system. When creating a new booking, this data will be read once and then cached in your application database.

# Exercise description

## 1. Import S/4 HANA service

> **For this exercise you have to switch to another code branch of the cloned Github repository**

1. In the Git pane, click the '+' icon to create a new local and link it to the desired remote branch. 

<p align="center"><img width="420" src="res/pic301.png" alt="Create local branch"> </p>

2. **Select the branch names as shown in the picture:**
<p align="center"><img width="420" src="res/pic302.png" alt="Create local branch"> </p>

3. **Check the branch name in the file explorer:**
<p align="center"><img width="330" src="res/pic303a.png" alt="Branch name in explorer"> </p>

4. **Find model of external service in SAP API Business Hub:**  Navigate to SAP API Business Hub by opening the url https://api.sap.com/ in a separate browser tab or window. Select the "Log On" button and enter the credentials. In the search field type "OData Service for Business Partner" and press the search icon.
![API Hub Search](res/pic303b.png)

5. **Select the first search result** ("OData Service for Business Partner"). On the next screen switch to the "Details" view. Scroll down to select "Download Specification" and then select "EDMX"
<p align="center"><img width="470" src="res/pic303c.png" alt="Select OData API" border=1> </p>
Store this file to your local computer.

6. **Import the service model into your project:** Switch back to SAP Web IDE and import the file stored on your computer as an external service definition, by right-mouse-click on the ``srv`` folder, then selecting "New" -> "DataModel from External Service":  
![TBD](res/pic306.png)

7. In the wizard, **import the previously stored file from your computer**. Then press "Next".
![TBD](res/pic308a.png)

8. **Uncheck the box "Generate Virtua Data Model classes" and press "Finish":**
![TBD](res/pic310.png)

9. **Verify that the import has generated two service definitions**, one in xml format ("edmx"), the other in json format ("cson").
<p align="center"><img width="350" src="res/pic311.png" alt="Imported files" border=1> </p>

## 2. Incorporate external entities into data and service model

1. **Remove comments in `db/index.cds`:**
![TBD](res/pic312.png)
![TBD](res/pic313.png)

2. **Remove comments in `srv/booking-service.cds`:**
![TBD](res/pic314.png)

3. **Build and deploy to the database:**
![TBD](res/pic319.png)
![TBD](res/pic320.png)

4. **Browse the database:**
<p align="center"><img width="400" src="res/pic326.png" alt="Browse the database" border=1> </p>


## 3. Change Java handler code: add S/4 calls

1. **Adjust `CustomersRemoteHandler.java`:** Change the line comments as indicated in the pictures.
![TBD](res/pic317.png)
![TBD](res/pic318.png)

2. **Run the Java application:**
<p align="center"><img width="500" src="res/pic321.png" alt="Run Java app" border=1> </p>

3. **Browse the Booking Service:** Click the url of the Java application in the run console:
![TBD](res/pic322.png)

4. **Select the BookingService endpoint to see the service metadata:** 
![TBD](res/pic323.png)
**Check the data retreived as "Bookings" and as "CustomerRemote":** 
![TBD](res/pic324.png)
![TBD](res/pic325.png)
Remote customers (read from S/4) are not yet persisted in our database ...

## 4. Prepare storing S/4 customers in the local database
1. **Adjust `BookingsHandler.java`:** Remove the line comments to match the following pictures.
![TBD](res/pic315.png)
![TBD](res/pic316.png)

2. **Run again:**
<p align="center"><img width="500" src="res/pic321.png" alt="Run Java app" border=1> </p>

## Create bookings for S/4 customers

1. **Adjust the UI:** The UI can be adapted when adding/changing Fiori annotations to CDS models. Remove the line comments for the section marked in the following figures:
![TBD](res/pic327.png)
![TBD](res/pic328.png)
![TBD](res/pic330.png)
![TBD](res/pic329.png)

2. **Run the UI within SAP Web IDE:**
<p align="center"><img width="600" src="res/pic331.png" alt="Imported files" border=1> </p>

<p align="center"><img width="600" src="res/pic332.png" alt="Imported files" border=1> </p>

<p align="center"><img width="700" src="res/pic333.png" alt="Imported files" border=1> </p>

3. **Create a new booking for an S/4 customer:**
![TBD](res/pic334.png)

4. **Check that this S/4 customer has been persisted (cached) in the database:**
![TBD](res/pic335.png)

