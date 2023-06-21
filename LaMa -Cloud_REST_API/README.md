## Table of Contents
1. [Description](#Description)

2. [Prerequisites](#Prerequisites_local_machine)

3. [Prerequisites](#Prerequisites_BTP_Cloud_Foundry)

3. [Samples](#Samples)

4. [How_To_Download](#How_To_Download)




## Description
In LaMa Cloud, REST API (inbound) has been added as a new feature. This new feature is described in the blog below that includes samples.

[SAP Landscape Management Cloud (LaMa Cloud) REST API Sample](https://blogs.sap.com/2023/06/21/sap-landscape-management-cloud-lama-cloud-rest-api-sample/)

The blog covers the following:

- Configuration of API Keys in LaMa Cloud
- Initial test with Postman
- API call to LaMa Cloud from a very simple Python web application on local machine (sample included here)
- API call to LaMa Cloud from the above app hosted in SAP BTP Cloud Foundry (sample included here)

Code sample is stored here as described below.

- server.py (main Python code)
- templates/table.html (html rendering)
- manifest.yml (Cloud Foundry resources for deployment)
- requirements.txt (Python libraries to use in Cloud Foundry)
- runtime.txt (Python version to use in Cloud Foundry)

## Prerequisites_local_machine

- % pip install flask
- % pip install tabulate

## Prerequisites_BTP_Cloud_Foundry

In addition to local machine prerequisites, you also need to do the following:

- You have a trial or productive account for SAP BTP. A new trial account can be created via [try out services for free](https://developers.sap.com/tutorials/btp-free-tier-account.html).
- You have created a subaccount and a space on Cloud Foundry Environment.
- Install npm : [refer to this site](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- Install the Cloud Foundry CLI : [refer to this guide](https://help.sap.com/products/BTP/65de2977205c403bbc107264b8eccf4b/4ef907afb1254e8286882a2bdef0edf4.html)
- Install virtualenv (pip install virtualenv)

## Samples
The files listed in the description section are stored in the samples folder. Copy the files including templates/table to a separate folder

## How_To_Download
If you are not a regular GitHub user and just want to download the XML files, please follow the below steps (in contrast to using clone):

- Go to the top level of the samples repository (https://github.com/SAP-samples/landscape-management-sample-scripts)
- Click on the Green button ("<> Code")
- Download ZIP
- In the ZIP file the samples files are located in LaMa-Cloud_REST_API/samples


