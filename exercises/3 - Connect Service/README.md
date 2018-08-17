# Exercise 03: Connect an S/4HANA service (business partner)

## Estimated time

25 minutes

## Objective

In this exercise you'll learn how to add a remote service to your app which fetches customer data from an S/4 system. This data will be read once and then cached in your application database.

# Exercise description

## 1. Import S/4 HANA service

1. For this exercise you have to switch to another code branch of the cloned Github repository. In the Git pane, click the '+' icon to create a new local and link it to the desired remote branch. 

<p align="center"><img width="420" src="res/pic301.png" alt="Create local branch"> </p>

2. Select the branch names as shown in the picture:
<p align="center"><img width="420" src="res/pic302.png" alt="Create local branch"> </p>

3. Check the branch name in the file explorer
<p align="center"><img width="330" src="res/pic303a.png" alt="Branch name in explorer"> </p>

4. Find model of external service in SAP API Business Hub:  Navigate to SAP API Business Hub by opening the url https://api.sap.com/ in a separate browser tab or window. Select the "Log On" button and enter the credentials. In the search field type "OData Service for Business Partner" and press the search icon.
![API Hub Search](res/pic303b.png)

5. Select the first search result ("OData Service for Business Partner"). On the next screen switch to the "Details" view. Scroll down to select "Download Specification" and then select "EDMX"
<p align="center"><img width="470" src="res/pic303c.png" alt="Select OData API" border=1> </p>
Store this file to your local computer.

6. Import the service model into your project: Switch back to SAP Web IDE and import the selected file as an external service definition.
![TBD](res/pic306.png)


9. xxxx
![TBD](res/pic308.png)

10. xxxx
![TBD](res/pic309.png)

11. xxxx
![TBD](res/pic310.png)

12. xxxx
![TBD](res/pic311.png)

## 2. Change model

1. Remove comments in `db/index.cds`
![TBD](res/pic312.png)
![TBD](res/pic313.png)

2. Remove comments in `srv/booking-service.cds`
![TBD](res/pic314.png)

3. Deploy to the database

![TBD](res/pic319.png)
![TBD](res/pic320.png)

4. Browse the database

![TBD](res/pic326.png)


## 3. Change custom code: add S/4 calls

1. Adjust `CustomersRemoteHandler`

![TBD](res/pic317.png)
![TBD](res/pic318.png)

2. Run

![TBD](res/pic321.png)
![TBD](res/pic322.png)

3. Browse

![TBD](res/pic323.png)
![TBD](res/pic324.png)
![TBD](res/pic325.png)


## 4. Show business partner
1. Adjust `BookingsHandler`

![TBD](res/pic315.png)
![TBD](res/pic316.png)

5. Run again

![TBD](res/pic321.png)

6. Adjust UI

![TBD](res/pic327.png)
![TBD](res/pic328.png)
![TBD](res/pic330.png)
![TBD](res/pic329.png)

7. Run UI

![TBD](res/pic331.png)
![TBD](res/pic332.png)
![TBD](res/pic333.png)
![TBD](res/pic334.png)
![TBD](res/pic335.png)

