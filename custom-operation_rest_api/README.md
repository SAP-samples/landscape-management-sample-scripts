## Table of Contents
1. [Description](#Description)

2. [Prerequisites](#Prerequisites)

3. [YAML_File](#YAML_File)

3. [XML_Files](#XML_Files)




## Description
In LaMa Enterprise Edition SP25, provider for calling REST API (outbound) has been added as a new feature. This new feature is described in the blog below that includes samples.

[SAP Landscape Management (LaMa) REST API Testing](https://blogs.sap.com/2022/11/30/introducing-the-rest-api-provider-in-sap-landscape-enterprise-edition-lama/)

Code sample and the xml files are stored here as described below.

Other related code samples prior to SP25 (inbound REST API, outbound API using scripts registered with hostagent) can be seen in the blogs below:

[Introducing the REST API Provider in SAP Landscape Management Enterprise Edition (LaMa)](https://blogs.sap.com/2018/11/22/sap-landscape-management-lama-rest-api-testing/)

[Outgoing API calls from SAP Landscape Management (LaMa) with Automation Studio](https://blogs.sap.com/2020/06/08/outgoing-api-calls-from-sap-landscape-management-lama-with-automation-studio/)

## Prerequisites
You must ensure that you make the necessary changes in the provider definitions to use the correct URLs. The XML files use dummy URLs and referring to the above blog you can identify the changes that are needed.

## YAML_File
The file figlet.yml (located in YAML_Files folder) is the playbook used by Ansible AWX or Ansible Tower. This would be accessed directly via the URL -  https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_rest_api/YAML_Files/figlet_rpm.yml

## XML_Files
The XML files (located in XML_Files folder) can be imported into LaMa and have the providers definitions, custom operations, and process described in the samples sections of the above blog.

- Custom Operation: "My Execute AWX template"<br>
Custom operation executed from an instance that makes REST API call to Ansible for executing the playbook to install the Linux utility "figlet", run the figlet command, and delete the Linux figlet utility. The provider definitions needed are part of this XML file

- Custom Operation: "Post to Slack BEGIN"<br>
Custom operation that posts a default message to a slack channel

- Custom Operation: "Post to Slack CUSTOM"<br>
Custom operation that posts a modifiable message to a slack channel

- Custom Process: "Patch Demo"<br>
Custom Process executed from an instance that performs steps to simulate an OS patching scenario. Instead of patching the operating system the Linux utility (figlet) will be installed and removed. The steps included are stop instance, post message to Slack (you will need to change the URL to match your own slack channel), execute the above custom operation, post another message to slack, and start the instance.

Note: If you are not a regular GitHub user and just want to download the XML files, please follow the below steps:

- Go to the top level of the samples repository (https://github.com/SAP-samples/landscape-management-sample-scripts)
- Click on the Green button ("<> Code")
- Download ZIP
- In the ZIP file the XML files are located in custom-operation_rest_api/XML_Files

![alt text](https://blogs.sap.com/wp-content/uploads/2022/11/custom1.png)