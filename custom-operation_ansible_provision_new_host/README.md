<h2 dir="auto" tabindex="-1">Table of Contents</h2>
<ol dir="auto">
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#Description">Description</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#Prerequisites">Prerequisites</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#YAML_File">YAML_File</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#XML_Files">XML_Files</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#How_To_Download">How_To_Download</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#Procedure">Procedure Summary</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#Ansible_Playbook">Ansible Playbook</a></p>
</li>
 	<li>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#tag">LaMa Configuration</a></p>
</li>
</ol>
<h2 dir="auto" tabindex="-1"><a id="user-content-description" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#description" aria-hidden="true"></a>Description</h2>
<p dir="auto">The information here is also documented in this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/">blog</a></p>
<p dir="auto">Ansible playbook that can be launched from LaMa to provision a new host on AWS to be used as a target for adding new application server.</p>
<p dir="auto">The diagram below illustrates at a high-level how the flow looks like.</p>
<p dir="auto"><a href="https://camo.githubusercontent.com/488d395292a41c3d161db1f5f3b278e391c1f194272e6a3b998c2dc886b00e27/68747470733a2f2f626c6f67732e7361702e636f6d2f77702d636f6e74656e742f75706c6f6164732f323032332f30342f41532d496e7374616c6c2e706e67" target="_blank" rel="noopener noreferrer nofollow"><img src="https://camo.githubusercontent.com/488d395292a41c3d161db1f5f3b278e391c1f194272e6a3b998c2dc886b00e27/68747470733a2f2f626c6f67732e7361702e636f6d2f77702d636f6e74656e742f75706c6f6164732f323032332f30342f41532d496e7374616c6c2e706e67" alt="LaMa AS Install" data-canonical-src="https://blogs.sap.com/wp-content/uploads/2023/04/AS-Install.png" /></a></p>

<h2 dir="auto" tabindex="-1"><a id="user-content-yaml_file" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#yaml_file" aria-hidden="true"></a>YAML_File</h2>
<p dir="auto">The file lama_create_vm.yaml (located in YAML_Files folder) is the playbook used by Ansible AWX or Ansible Tower. AWX/Tower URL:</p>
<p dir="auto"><a href="https://github.com/SAP-samples/landscape-management-sample-scripts">https://github.com/SAP-samples/landscape-management-sample-scripts</a></p>
<p dir="auto">Playbook: custom-operation_ansible_provision_new_host/YAML_Files/lama_create_vm.yaml</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-xml_files" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#xml_files" aria-hidden="true"></a>XML_Files</h2>
<p dir="auto">The XML files (located in XML_Files folder) can be imported into LaMa and have the providers definitions, custom operations, and process described in the samples sections of the above blog (to be added).</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-how_to_download" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#how_to_download" aria-hidden="true"></a>How_To_Download</h2>
<p dir="auto">If you are not a regular GitHub user and just want to download the XML files, please follow the below steps (in contrast to using clone):</p>

<ul dir="auto">
 	<li>Go to the top level of the samples repository (<a href="https://github.com/SAP-samples/landscape-management-sample-scripts">https://github.com/SAP-samples/landscape-management-sample-scripts</a>)</li>
 	<li>Click on the Green button ("&lt;&gt; Code")</li>
 	<li>Download ZIP</li>
 	<li>In the ZIP file the XML files are located in custom-operation_rest_api/XML_Files</li>
</ul>
<h2 dir="auto" tabindex="-1"><a id="user-content-procedure" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#procedure" aria-hidden="true"></a>Procedure</h2>
<p dir="auto">What is covered here includes the scenario of provisioning a new virtual machine instance in a public cloud directly from LaMa and then using this new host to perform an operation (e.g. new HANA replication tier, add application server, system copy/clone).</p>
<p dir="auto">AWS (Amazon Web Services) is used as the public cloud and Ansible AWX (upstream open source project for Ansible Tower) to launch the playbook for the creation of a new instance. The same approach also applies to Azure or GCP. The module used in the playbook can be replaced by those for the other cloud providers and some other minor adjustments.</p>
<p dir="auto">In this <a href="https://blogs.sap.com/2022/11/30/introducing-the-rest-api-provider-in-sap-landscape-management-enterprise-edition-lama/" rel="nofollow">blog</a>, I described the outbound REST API feature of LaMa that was first added in SP25.</p>
<p dir="auto">The ansible playbook (for use in Ansible AWS or Tower) and the LaMa configuration (provider definitions, custom operations, etc.) are available here.</p>
<p dir="auto">The REST provider that is part of automation studio will be used to trigger the new host provisioning via Ansible AWX, followed by a discovery and then using the new host to provision an additional application server.</p>
<p dir="auto">It is also possible to use the newly added host for other provisioning tasks such as system copy or new replication tier.</p>
<p dir="auto">It should be noted that when using some cloud adapters in LaMa (such as the Cloud Manager for AWS), it is already possible to provision new cloud instances as part of tasks like "Install Application Server" or "System Copy". The choices presented are to use existing hosts (already discovered in LaMa as ready to use) or provision a new host. However, the built-in process does not always meet the requirements for some customers. For example, there may be a need to customize the instance further before it is used. In this case, this alternative approach with Ansible can be used.</p>

<h3 dir="auto" tabindex="-1"><a id="user-content-disclaimer" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#disclaimer" aria-hidden="true"></a>Disclaimer</h3>
<p dir="auto">This procedure is published “AS IS”. Any software coding and/or code lines / strings (“Code”) included are only examples and are not intended to be used in any productive system environment. The Code is only intended to better explain and visualize the features of the SAP Landscape Management Automation Studio. No effort has been made to make the code production quality (e.g. security, error handling, robustness, etc). If you use any of the code shown, you are doing it at your own risk.</p>
<p dir="auto">Information in here could include technical inaccuracies or typographical errors. Changes may be periodically made.</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-ansible_playbook" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#ansible_playbook" aria-hidden="true"></a>Ansible_Playbook</h2>
<p dir="auto">This is the <a href="https://github.com/SAP-samples/landscape-management-sample-scripts/blob/main/custom-operation_ansible_provision_new_host/YAML_Files/lama_create_vm.yaml">playbook on GitHub</a>.</p>
<p dir="auto">The procedure does not cover how to configure Ansible AWX.</p>
<p dir="auto">The following key configuration steps need to be performed and relevant guides consulted. These are just the configuration steps performed for this scenario and not necessarily the only way to do it.</p>

<ul dir="auto">
 	<li>Add SSH <a href="https://docs.ansible.com/automation-controller/latest/html/userguide/credentials.html#add-a-new-credential" rel="nofollow">credentials</a></li>
 	<li>Add AWS <a href="https://docs.ansible.com/automation-controller/latest/html/userguide/credentials.html#add-a-new-credential" rel="nofollow">credentials</a></li>
 	<li>Add <a href="https://docs.ansible.com/automation-controller/latest/html/userguide/inventories.html#add-a-new-inventory" rel="nofollow">Inventory</a></li>
 	<li>Add <a href="https://docs.ansible.com/automation-controller/latest/html/userguide/inventories.html#ug-inventories-add-host" rel="nofollow">host</a> — optional as the playbook itself will make the entries but you add an existing host to just have an entry in addition to localhost</li>
 	<li>Add <a href="https://docs.ansible.com/ansible-tower/latest/html/quickstart/create_job.html" rel="nofollow">Project</a> (source control type = Git; Source control URL = url)</li>
 	<li>Add <a href="https://docs.ansible.com/ansible-tower/latest/html/quickstart/create_job.html" rel="nofollow">Job Template</a> (assign above Project and Inventory; Also assign above credentials – SSH and AWS)</li>
 	<li>A Survey also needs to be added and enabled – described further down</li>
 	<li>Create a new <a href="https://docs.ansible.com/automation-controller/latest/html/userguide/applications_auth.html#create-a-new-application" rel="nofollow">Application</a> (Note down the Client ID and Client Secret – we will need it in LaMa)
<ul dir="auto">
 	<li>Authorization grant type: Resource owner password-based</li>
 	<li>Client type: Confidential</li>
</ul>
</li>
</ul>
<p dir="auto">Figure out your job template ID and note it down.</p>
<p dir="auto">The playbook takes the following parameters and should be added as “Survey” in the job template:</p>

<ul dir="auto">
 	<li>i_name (name assigned to the instance as well as the hostname at OS level)</li>
 	<li>i_type (the AWS instance type that matches your requirements – e.g. t2.xlarge)</li>
 	<li>i_subnet (the subnet id where your SAP landscape is installed)</li>
 	<li>i_secgrp (the security group id applicable to your landscape)</li>
 	<li>i_keypair (the private key file that has also been stored in Ansible AWX to allow SSH)</li>
 	<li>i_ami (the image file to use – this can be an image that you have taken from an existing server act as a starting point for further configuration as needed)</li>
 	<li>lama_ip (IP address of LaMa)</li>
 	<li>awx_username (credential for AWX/Tower)</li>
 	<li>awx_password (credential for AWX/Tower)</li>
</ul>
<p dir="auto">When calling from LaMa the initial authentication credentials needed to launch the playbook will also be passed automatically. So the input of credentials is only once.</p>
<p dir="auto">The playbook has multiple plays within it and summarized below:</p>

<ul dir="auto">
 	<li>Play on localhost – runs on the Ansible AWX system
<ul dir="auto">
 	<li>Create a VM: Uses the amazon.aws.ec2_instance module to create the instance in AWS</li>
 	<li>Get EC2 Info: Uses the modeule “amazon.aws.ec2_instance_info” to gathers info on the instance that we can use later</li>
 	<li>Display private IP address: Determine what private IP address got assigned by AWS</li>
 	<li>Register host in AWX Inventory: Uses the “uri” module to register host in Ansible AWX</li>
 	<li>Add host to dynamic inventory: Uses the “add_host” module to add host in the in-memory inventory. This allows us to use it as variable in the next play.</li>
 	<li>DNS A record: Using the amazon.aws.route53 module it creates a new “A” record in our DNS private zone</li>
 	<li>DNS PTR record: Using the amazon.aws.route53 module it creates a new “PTR” record in our DNS private zone</li>
</ul>
</li>
 	<li>Play on new host – runs on the new instance created above
<ul dir="auto">
 	<li>Assigns a hostname at the OS level</li>
 	<li>Mounts a NFS filesystem on /mnt mount point -&gt; this has a script and the latest version of SAP Host Agent and Adaptive Extensions</li>
 	<li>Script is executed that performs an installation or upgrade of SAP Host Agent/Adaptive Extensions</li>
 	<li>Script adds entry into /etc/hosts for LaMa -&gt; not necessary when using DNS but useful as a fallback and needed if not using DNS</li>
 	<li>Sets the password for sapadm account -&gt; needed as host is not using LDAP</li>
 	<li>Unmount the NFS share</li>
 	<li>Stores the hostname and IP address of new instance in variables to be used in next play</li>
</ul>
</li>
 	<li>Play on LaMa Host
<ul dir="auto">
 	<li>Update /etc/hosts file: Uses the ansible.builtin.lineinfile module and the variables set in previous play
<ul dir="auto">
 	<li>Not mandatory if using DNS but good to have anyway</li>
</ul>
</li>
</ul>
</li>
</ul>
<p dir="auto">Prior to configuring LaMa, test the template directly in AWX/Tower web UI. If it successfully creates a new instance then move to the LaMa section. Terminate the test instance.</p>
<p dir="auto"><a name="user-content-tag"></a></p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-provider-definitions-calls-to-ansible-awxtower" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-provider-definitions-calls-to-ansible-awxtower" aria-hidden="true"></a>LaMa Provider Definitions: Calls to Ansible AWX/Tower</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag1" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-custom-operation-create-vm-call-to-ansible-awxtower" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-custom-operation-create-vm-call-to-ansible-awxtower" aria-hidden="true"></a>LaMa Custom Operation: Create VM (call to Ansible AWX/Tower)</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag2" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-provisioning-blueprint" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-provisioning-blueprint" aria-hidden="true"></a>LaMa Provisioning Blueprint</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag3" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-provider-definitions-lama-to-lama-rest-api-call" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-provider-definitions-lama-to-lama-rest-api-call" aria-hidden="true"></a>LaMa Provider Definitions (LaMa to LaMa REST API call)</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag4" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-provider-definition-for-hook-sleep-120-seconds" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-provider-definition-for-hook-sleep-120-seconds" aria-hidden="true"></a>LaMa Provider Definition for Hook: Sleep 120 Seconds</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag5" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-custom-operation-discover-vm-lama-to-lama-rest-api-calls" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-custom-operation-discover-vm-lama-to-lama-rest-api-calls" aria-hidden="true"></a>LaMa Custom Operation: Discover VM (LaMa to LaMa REST API calls)</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag6" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-custom-operation-trigger-blueprint-lama-to-lama-rest-api-calls" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-custom-operation-trigger-blueprint-lama-to-lama-rest-api-calls" aria-hidden="true"></a>LaMa Custom Operation: Trigger Blueprint (LaMa to LaMa REST API calls)</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag7" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-custom-hook" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-custom-hook" aria-hidden="true"></a>LaMa Custom Hook</h2>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag8" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-custom-process" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-custom-process" aria-hidden="true"></a>LaMa Custom Process</h2>
<p dir="auto"><a href="https://camo.githubusercontent.com/72b1808e4a21ed62e3d1a216b1371e6744b00af950c8f3f2ab01400e89a4af0d/68747470733a2f2f626c6f67732e7361702e636f6d2f77702d636f6e74656e742f75706c6f6164732f323032332f30342f637573746f6d5f70726f636573732d312e706e67" target="_blank" rel="noopener noreferrer nofollow"><img src="https://camo.githubusercontent.com/72b1808e4a21ed62e3d1a216b1371e6744b00af950c8f3f2ab01400e89a4af0d/68747470733a2f2f626c6f67732e7361702e636f6d2f77702d636f6e74656e742f75706c6f6164732f323032332f30342f637573746f6d5f70726f636573732d312e706e67" alt="LaMa Ansible Custom Process" data-canonical-src="https://blogs.sap.com/wp-content/uploads/2023/04/custom_process-1.png" /></a></p>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag9" target="_blank" rel="nofollow">blog section</a> for details</p>

<h2 dir="auto" tabindex="-1"><a id="user-content-lama-custom-process-execution" class="anchor" href="https://github.com/SAP-samples/landscape-management-sample-scripts/tree/main/custom-operation_ansible_provision_new_host#lama-custom-process-execution" aria-hidden="true"></a>LaMa Custom Process Execution</h2>
<p dir="auto"><a href="https://camo.githubusercontent.com/bbd730537fc3726ac643a55c06d555f27b81c533933f9d760072ac2ca4f3ffe4/68747470733a2f2f626c6f67732e7361702e636f6d2f77702d636f6e74656e742f75706c6f6164732f323032332f30342f657865637574696f6e5f637573746f6d5f70726f636573732d322e706e67" target="_blank" rel="noopener noreferrer nofollow"><img src="https://camo.githubusercontent.com/bbd730537fc3726ac643a55c06d555f27b81c533933f9d760072ac2ca4f3ffe4/68747470733a2f2f626c6f67732e7361702e636f6d2f77702d636f6e74656e742f75706c6f6164732f323032332f30342f657865637574696f6e5f637573746f6d5f70726f636573732d322e706e67" alt="Custom Process Execution" data-canonical-src="https://blogs.sap.com/wp-content/uploads/2023/04/execution_custom_process-2.png" /></a></p>
<p dir="auto">Refer to this <a href="https://blogs.sap.com/2023/04/12/sap-landscape-management-lama-ansible-tower-awx-provisioning-of-cloud-instances-with-rest-api/#tag10" target="_blank" rel="nofollow">blog section</a> for details</p>