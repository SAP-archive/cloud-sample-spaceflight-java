# Mocking OData APIs of SAP S/4HANA

The mock server provided by SAP S/4HANA Cloud SDK can be used to test the OData integration capabilities without access to an SAP S/4HANA system.  The server hosts an OData v2 mock service that mimicks the business partner API of SAP S/4HANA Cloud to a limited extent.

> Find more information on the [mock server](https://github.com/SAP/cloud-s4-sdk-book/tree/mock-server).


## Setup

1. In the Web IDE Git pane select the **master** branch:
   <p align="left"><img width="480" src="res/00-SwitchBranch.png" alt="Checkout master branch"> </p>


2. Deploy the MTA archive

   For your convenience, there is a prebuilt MTA archive for the mock server that can be easily deployed from Web IDE.
   Find the `.mtar` file below `-mock-server-`, right-click on it, and execute `Deploy`"
   <p align="left"><img width="480" src="res/01-DeployMta.png" alt="Deploy mock server MTA"> </p>

   Enter the credentials for Cloud Foundry:
   <p align="left"><img width="480" src="res/02-DeployMtaCredentials.png" alt="Enter deploy credentials" border=1> </p>

   In Web IDE's console view, wait for the deployment to finish.  Copy the application URL from the console to your clipboard.
   <p align="left"><img width="480" src="res/03-DeployMtaURL.png" alt="Copy application URL" border=1> </p>

3. Create a destination in Cloud Cockpit

   In Cloud Cockpit, go to the _Destination_ list for your subaccount.
   <p align="left"><img width="480" src="res/04-NewDestination.png" alt="Create destination"> </p>

   > Make sure to have _OrgManager_ permissions, otherwise you won't see the _Destinations_ panel.

   As destination name, enter `ErpQueryEndpoint`.  As URL, paste the application URL from your clipboard.
   <p align="left"><img width="480" src="res/05-DestinationCredentials.png" alt="Enter destination details" border=1> </p>

   > `ErpQueryEndpoint` is used as default destination name by S/4HANA Cloud SDK.  See the [SDK documentation](https://blogs.sap.com/2018/01/19/deep-dive-7-with-sap-s4hana-cloud-sdk-s4hana-connectivity-made-simple/) for more information.

   After having saved the destination, click on _Check Connection_ to verify the server responds with return code `200 OK`.
   <p align="left"><img width="480" src="res/06-CheckConnection.png" alt="Check destination connection"> </p>

## Next
From here on, the application uses the server as if it would be a live SAP S/4HANA system.

Continue with the [exercise](../README.MD).
