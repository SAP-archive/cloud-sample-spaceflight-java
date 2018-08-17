# Exercise 03: Connect an S/4HANA service (business partner)

## Estimated time

25 minutes

## Objective

In this exercise you'll learn how to add a remote service to your app which fetches customer data from an S/4 system. This data will be read once and then cached in your application database.

# Exercise description

## 1. Import S/4 HANA service

1. For this exercise you have to switch to another code branch of the cloned Github repository. In the Git pane, click the '+' icon to create a new local and link it to the desired remote branch. 
<div style="text-align: center"><img src="res/pic301.png" width="400" height="200"></div>
<center><img src="res/pic301.png" alt="Create local branch" width="400px"/></center>
<img src="res/pic301.png" alt="Create local branch" width="400px"/>

Select the branch names as shown in the picture:



Click on the symbol on the right of the browser and click on `Pull` and after that on the `Fetch` symbol.


2. Once this has worked, you should see an information at the top right saying `Pull completed.` and `Fetch completed`
![TBD](res/pic302.png)

3. Not sure what we have done here before TBD TBD TBD
![TBD](res/pic303.png)

4. xxxx
![TBD](res/pic304.png)

5. xxxx
![TBD](res/pic305.png)

6. xxxx
![TBD](res/pic306.png)

7. xxxx
![TBD](res/pic306.png)

8. xxxx
![TBD](res/pic307.png)

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

