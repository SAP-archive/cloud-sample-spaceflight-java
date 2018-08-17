# Exercise 04: How to build your own reuse model and consume it in your app

## Estimated time

25 minutes

## Objective

In this exercise you'll learn how to reuse CDS model code from other applications.

# Exercise description

## 1. Preparation
1. For this exercise you have to switch to another code branch of the code you've cloned from Github. Click on the symbol on the right of the browser and click on `Pull` and after that on the `Fetch` symbol.
![New branch](res/1.png)

2. Checkout the `reuse-start` branch:
![Checkout reuse-start branch](res/2.png)

2. Once this has worked, you should see an information at the top right saying `Pull completed.` and `Fetch completed`

> Your will find the final state of this exercise in branch `reuse-final`.


## 2. Add dependency to base model repo

1. Locate `package.json` at root level

![package.json](res/3.png)

2. Adjust `package.json` in the following two places
![package.json](res/4.png)
![package.json](res/5.png)

3. Let's see which files we get from the imported model

- Execute _Build CDS_ on the project

  ![Build cds](res/9.png)

- Find `node_modules/spaceflight-model` and see the model files

  ![Browse node_modules](res/10.png)

4. Remove redundant model code

- Delete files `common.cds`, `flight-model.cds`, and `space-model.cds`.  These files are now used from the reuse model.
  ![Delete files](res/7.png)

- Remove the first two lines of `index.cds`.  Comment in the last line.
  ![index.cds](res/6.png)

- Comment in the first line of `srv/booking-service.cds`.  Remove the rest of the lines.
  ![booking-service.cds](res/8.png)


5. Deploy to database
  ![index.cds](res/11.png)

6. Browse database
- Open database explorer:

  ![index.cds](res/12.png)

- See that we got 4 more columns in the `BOOKINGS` table:

  ![index.cds](res/13.png)
  These are admin data from `node_modules/@sap/cds/common.cds`, which we inherit through `node_modules/spaceflight-model/db/common.cds`.