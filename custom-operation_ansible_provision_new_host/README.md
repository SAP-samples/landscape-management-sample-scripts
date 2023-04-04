## Table of Contents
1. [Description](#Description)

2. [Prerequisites](#Prerequisites)

3. [YAML_File](#YAML_File)

4. [XML_Files](#XML_Files)

5. [How_To_Download](#How_To_Download)




## Description
Ansible playbook that can be launched from LaMa to provision a new host on AWS to be used as a target for adding new application server.

WIP - More details to follow soon

## Prerequisites
WIP - More details to follow soon

## YAML_File
The file lama_create_vm.yaml (located in YAML_Files folder) is the playbook used by Ansible AWX or Ansible Tower. AWX/Tower URL:

https://github.com/SAP-samples/landscape-management-sample-scripts

Playbook: custom-operation_ansible_provision_new_host/YAML_Files/lama_create_vm.yaml


## XML_Files
The XML files (located in XML_Files folder) can be imported into LaMa and have the providers definitions, custom operations, and process described in the samples sections of the above blog (to be added).

- Custom Operation: "XX"<br>
Custom operation executed from an instance that makes REST API call to Ansible for executing the playbook to create the instance ready to be discovered by LaMa

- Custom Operation: "XX"<br>
WIP - More details to follow soon

- Custom Operation: "XX"<br>
WIP - More details to follow soon

- Custom Process: "XX"<br>
WIP - More details to follow soon



## How_To_Download
If you are not a regular GitHub user and just want to download the XML files, please follow the below steps (in contrast to using clone):

- Go to the top level of the samples repository (https://github.com/SAP-samples/landscape-management-sample-scripts)
- Click on the Green button ("<> Code")
- Download ZIP
- In the ZIP file the XML files are located in custom-operation_rest_api/XML_Files


