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

## Procedure

Introduction
In this blog, I will cover the scenario of provisioning a new instance in a public cloud directly from LaMa and then using this new host to perform an operation (e.g. new HANA replication tier, add application server, system copy/clone).

I will use AWS (Amazon Web Services) as the public cloud and Ansible AWX (upstream open source project for Ansible Tower) to launch the playbook for the creation of a new instance. The same approach also applies to Azure or GCP. The module used in the playbook can be replaced by those for the other cloud providers and some other minor adjustments.

In a previous blog, I described the outbound REST API feature of LaMa that was first added in SP25.

The ansible playbook (for use in Ansible AWS or Tower) and the LaMa configuration (provider definitions, custom operations, etc.) are available at GitHub.

Scenario Description
The REST provider that is part of automation studio will be used to trigger the new host provisioning via Ansible AWX, followed by a discovery and then using the new host to provision an additional application server.

It is also possible to use the newly added host for other provisioning tasks such as system copy or new replication tier.

The diagram below illustrates at a high-level how the flow looks like.

High-level diagram

It should be noted that when using some cloud adapters in LaMa (such as the Cloud Manager for AWS), it is already possible to provision new cloud instances as part of tasks like "Install Application Server" or "System Copy". The choices presented are to use existing hosts (already discovered in LaMa as ready to use) or provision a new host. However, the built-in process does not always meet the requirements for some customers. For example, there may be a need to customize the instance further before it is used. In this case, this alternative approach with Ansible can be used.

Disclaimer
This blog is published "AS IS". Any software coding and/or code lines/strings ("Code") included are only examples and are not intended to be used in any productive system environment. The Code is only intended to better explain and visualize the features of the SAP Landscape Management Automation Studio. No effort has been made to make the code production quality (e.g. security, error handling, robustness, etc.). If you use any of the code shown, you are doing it at your own risk.

Information in this blog could include technical inaccuracies or typographical errors. Changes may be periodically made.

# Ansible Playbook

This is the playbook on GitHub.

The blog does not cover how to configure Ansible AWX.

The following key configuration steps need to be performed and relevant guides consulted. These are just the configuration steps performed for this scenario and not necessarily the only way to do it.

- Add SSH credentials
- Add AWS credentials
- Add Inventory
- Add host — optional as the playbook itself will make the entries but you add an existing host to just have an entry in addition to localhost
- Add Project (source control type = Git; Source control URL = url)
- Add Job Template (assign above Project and Inventory; Also assign above credentials – SSH and AWS)
- A Survey also needs to be added and enabled – described further down
- Create a new Application (Note down the Client ID and Client Secret – we will need it in LaMa)
    - Authorization grant type: Resource owner password-based
    - Client type: Confidential

Figure out your job template ID and note it down.


The playbook takes the following parameters and