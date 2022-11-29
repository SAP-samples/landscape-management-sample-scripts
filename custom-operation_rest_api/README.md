## Table of Contents
1. [Description](#Description)

2. [Prerequisites](#Prerequisites)

3. [Configuration](#Configuration)





## Description
WIP - New blog about REST Provider in LaMa SP25 to be published. Code samples and xml files will be stored here shortly after release.

Other related code samples prior to SP25 (inbound REST API, outbound API using scripts registered with hostagent) can be seen in the blogs below:

[SAP Landscape Management (LaMa) REST API Testing](https://blogs.sap.com/2018/11/22/sap-landscape-management-lama-rest-api-testing/)

[Outgoing API calls from SAP Landscape Management (LaMa) with Automation Studio](https://blogs.sap.com/2020/06/08/outgoing-api-calls-from-sap-landscape-management-lama-with-automation-studio/)

## Prerequisites
You must ensure that you make the necessary changes in the provider definitions to use the correct URLs. The XML file uses dummy URLs and referring to the above blog you can identify the changes that are needed.

## YAML file
The file figlet.yml (located at ..) is the playbook used by Ansible AWX or Ansible Tower. This would be accessed directly via the URL xx

## XML file
The XML file "xxx" can be imported into LaMa and have the custom operations and processes described in the samples sections of the above blog.

- Custom Operation: "My Execute AWX template"<br>
	&emsp;- Custom operation executed from an instance that makes REST API call to Ansible for executing the playbook to install the Linux utility "figlet", run the figlet command, and delete the Linux figlet utility. The provider definitions needed are part of this XML file

- Custom Process: "Patch Demo"<br>
	&emsp;- Custom Process executed from an instance that performs steps to simulate an OS patching scenario. Instead of patching the operating system the Linux utility (figlet) will be installed and removed. The steps included are stop instance, post message to Slack (you will need to change the URL to match your own slack channel), execute the above custom operation, post another message to slack, and start the instance.

![alt text](https://blogs.sap.com/wp-content/uploads/2022/11/custom1.png)