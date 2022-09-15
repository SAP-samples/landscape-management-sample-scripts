## Table of Contents
1. [Description](#Description)

2. [Prerequisites](#Prerequisites)

3. [Configuration](#Configuration)

4. [Execution](#Execution)



## Description
With these custom operations you'll enable your LaMa to run SYBASE DB & client updates in your environment.
The execution is based on note (2800483) [https://launchpad.support.sap.com/#/notes/2800483].


[Epic]

[User Story]

LaMa version: 

[Documentation]

Responsible consultant: 



## Prerequisites
Check the prerequisites of note (2800483) [https://launchpad.support.sap.com/#/notes/2800483].
Further more you need to prepare an update directory for your sybase update files (DB + Client). The path of this directory needs to be provided to the custom operations.

## Configuration
Please upload the provider definitions and custom operations into your SAP LaMa system.
The file ["Custom_Sybase.xml"](./LaMa_Config/Custom_Sybase.xml) contains the required content.
Provider definitions:
* SYBASE_CLIENT_UPDATE
* SYBASE_PREPARE_UPDATE
* SYBASE_UPDATE

Custom Operations:
* SYBASE_CLIENT_UPDATE
* SYBASE_PREPARE_UPDATE
* SYBASE_UPDATE

Furthermore you need to store the following .conf files in the directory /usr/sap/hostctrl/exe/operations.d on each and every server where those custom operations should get executed in the future:
* prepare_sybase_upd.conf
* update_sybase.conf
* update_sybase_client.conf

Also store the .sh file Sybase_update_check in the operations.d folder parallel to the .conf files.
*Sybase_update_check.sh
## Execution
Now you're able to use the three Custom Operations to prepare and update your Sybase DB and client.
You can either execute them on a standalone base or embed the steps in a custom process of your choice:
e.g.:
1. SYBASE_PREPARE_UPDATE
2. Stop PAS
3. SYBASE_UPDATE
4. SYBASE_CLIENT_UPDATE
5. Start PAS

