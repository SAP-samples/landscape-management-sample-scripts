## Table of Contents
1. [Description](#Description)

2. [Prerequisites](#Prerequisites)

3. [YAML_File](#YAML_File)

4. [XML_Files](#XML_Files)

5. [How_To_Download](#How_To_Download)

6. [Procedure Summary](#Procedure)

7. [Ansible Playbook](#Ansible_Playbook)

8. [LaMa Configuration](#tag)




## Description
Ansible playbook that can be launched from LaMa to provision a new host on AWS to be used as a target for adding new application server.

The diagram below illustrates at a high-level how the flow looks like.

<img src="https://blogs.sap.com/wp-content/uploads/2023/04/AS-Install.png"
     alt="LaMa AS Install"
     style="float: left; margin-right: 10px;" />


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

What is covered here includes the scenario of provisioning a new virtual machine instance in a public cloud directly from LaMa and then using this new host to perform an operation (e.g. new HANA replication tier, add application server, system copy/clone).

AWS (Amazon Web Services) is used as the public cloud and Ansible AWX (upstream open source project for Ansible Tower) to launch the playbook for the creation of a new instance. The same approach also applies to Azure or GCP. The module used in the playbook can be replaced by those for the other cloud providers and some other minor adjustments.

In this [blog](https://blogs.sap.com/2022/11/30/introducing-the-rest-api-provider-in-sap-landscape-management-enterprise-edition-lama/), I described the outbound REST API feature of LaMa that was first added in SP25.

The ansible playbook (for use in Ansible AWS or Tower) and the LaMa configuration (provider definitions, custom operations, etc.) are available here.

The REST provider that is part of automation studio will be used to trigger the new host provisioning via Ansible AWX, followed by a discovery and then using the new host to provision an additional application server.

It is also possible to use the newly added host for other provisioning tasks such as system copy or new replication tier.


It should be noted that when using some cloud adapters in LaMa (such as the Cloud Manager for AWS), it is already possible to provision new cloud instances as part of tasks like "Install Application Server" or "System Copy". The choices presented are to use existing hosts (already discovered in LaMa as ready to use) or provision a new host. However, the built-in process does not always meet the requirements for some customers. For example, there may be a need to customize the instance further before it is used. In this case, this alternative approach with Ansible can be used.

### Disclaimer

This procedure is published “AS IS”. Any software coding and/or code lines / strings (“Code”) included are only examples and are not intended to be used in any productive system environment. The Code is only intended to better explain and visualize the features of the SAP Landscape Management Automation Studio. No effort has been made to make the code production quality (e.g. security, error handling, robustness, etc). If you use any of the code shown, you are doing it at your own risk.

Information in here could include technical inaccuracies or typographical errors. Changes may be periodically made.

## Ansible_Playbook

This is the [playbook on GitHub](https://github.com/SAP-samples/landscape-management-sample-scripts/blob/main/custom-operation_ansible_provision_new_host/YAML_Files/lama_create_vm.yaml).

The procedure does not cover how to configure Ansible AWX.

The following key configuration steps need to be performed and relevant guides consulted. These are just the configuration steps performed for this scenario and not necessarily the only way to do it.

- Add SSH [credentials](https://docs.ansible.com/automation-controller/latest/html/userguide/credentials.html#add-a-new-credential)
- Add AWS [credentials](https://docs.ansible.com/automation-controller/latest/html/userguide/credentials.html#add-a-new-credential)
- Add [Inventory](https://docs.ansible.com/automation-controller/latest/html/userguide/inventories.html#add-a-new-inventory)
- Add [host](https://docs.ansible.com/automation-controller/latest/html/userguide/inventories.html#ug-inventories-add-host) — optional as the playbook itself will make the entries but you add an existing host to just have an entry in addition to localhost
- Add [Project](https://docs.ansible.com/ansible-tower/latest/html/quickstart/create_job.html) (source control type = Git; Source control URL = url)
- Add [Job Template](https://docs.ansible.com/ansible-tower/latest/html/quickstart/create_job.html) (assign above Project and Inventory; Also assign above credentials – SSH and AWS)
- A Survey also needs to be added and enabled – described further down
- Create a new [Application](https://docs.ansible.com/automation-controller/latest/html/userguide/applications_auth.html#create-a-new-application) (Note down the Client ID and Client Secret – we will need it in LaMa)
    - Authorization grant type: Resource owner password-based
    - Client type: Confidential

Figure out your job template ID and note it down.


The playbook takes the following parameters and should be added as “Survey” in the job template:

- i_name (name assigned to the instance as well as the hostname at OS level)
- i_type (the AWS instance type that matches your requirements – e.g. t2.xlarge)
- i_subnet (the subnet id where your SAP landscape is installed)
- i_secgrp (the security group id applicable to your landscape)
- i_keypair (the private key file that has also been stored in Ansible AWX to allow SSH)
- i_ami (the image file to use – this can be an image that you have taken from an existing server act  as a starting point for further configuration as needed)
- lama_ip (IP address of LaMa)
- awx_username (credential for AWX/Tower)
- awx_password (credential for AWX/Tower)

When calling from LaMa the initial authentication credentials needed to launch the playbook will also be passed automatically. So the input of credentials is only once.

The playbook has multiple plays within it and summarized below:

- Play on localhost – runs on the Ansible AWX system
    - Create a VM: Uses the amazon.aws.ec2_instance module to create the instance in AWS
    - Get EC2 Info: Uses the modeule “amazon.aws.ec2_instance_info” to gathers info on the instance that we can use later
    - Display private IP address: Determine what private IP address got assigned by AWS
    - Register host in AWX Inventory: Uses the “uri” module to register host in Ansible AWX
    - Add host to dynamic inventory: Uses the “add_host” module to add host in the in-memory inventory. This allows us to use it as variable in the next play.
    - DNS A record: Using the amazon.aws.route53 module it creates a new “A” record in our DNS private zone
    - DNS PTR record: Using the amazon.aws.route53 module it creates a new “PTR” record in our DNS private zone
- Play on new host – runs on the new instance created above
    - Assigns a hostname at the OS level
    - Mounts a NFS filesystem on /mnt mount point -> this has a script and the latest version of SAP Host Agent and Adaptive Extensions
    - Script is executed that performs an installation or upgrade of SAP Host Agent/Adaptive Extensions
    - Script adds entry into /etc/hosts for LaMa -> not necessary when using DNS but useful as a fallback and needed if not using DNS
    - Sets the password for sapadm account -> needed as host is not using LDAP
    - Unmount the NFS share
    - Stores the hostname and IP address of new instance in variables to be used in next play
- Play on LaMa Host
    - Update /etc/hosts file: Uses the ansible.builtin.lineinfile module and the variables set in previous play
         - Not mandatory if using DNS but good to have anyway
	
Prior to configuring LaMa, test the template directly in AWX/Tower web UI. If it successfully creates a new instance then move to the LaMa section. Terminate the test instance.

<a name="tag"></a>

## LaMa Provider Definitions: Calls to Ansible AWX/Tower
Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag1" target="_blank">blog section</a> for details

## LaMa Custom Operation: Create VM (call to Ansible AWX/Tower)
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag2) for details


## LaMa Provisioning Blueprint
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag3) for details

## LaMa Provider Definitions (LaMa to LaMa REST API call)
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag4) for details

## LaMa Provider Definition for Hook: Sleep 120 Seconds
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag5) for details

## LaMa Custom Operation: Discover VM (LaMa to LaMa REST API calls)
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag6) for details

## LaMa Custom Operation: Trigger Blueprint (LaMa to LaMa REST API calls)
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag7) for details

## LaMa Custom Hook
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag8) for details

## LaMa Custom Process
<img src="https://blogs.sap.com/wp-content/uploads/2023/04/custom_process-1.png"
     alt="LaMa Ansible Custom Process"
     style="float: left; margin-right: 10px;" />

Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag9) for details

## LaMa Custom Process Execution
<img src="https://blogs.sap.com/wp-content/uploads/2023/04/execution_custom_process-2.png"
     alt="Custom Process Execution"
     style="float: left; margin-right: 10px;" />
	 
Refer to this [blog section](https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag10) for details