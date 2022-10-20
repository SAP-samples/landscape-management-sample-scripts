#!/usr/bin/python

import subprocess
import argparse
#import getpass
import textwrap
#import time
import datetime
import yaml
import os
from xmlrpc.client import ServerProxy, DateTime
import logging
import shutil
from os import access, R_OK
from os.path import isfile


pid = os.getpid()
logfilename = "/var/log/susemanager/log/LaMa_suma_checkhosts_" + str(pid) + ".log"
mylogs = logging.getLogger(__name__)
mylogs.setLevel(logging.DEBUG)
#file handler adding here, log file should be overwritten every time as this will be sent via email
file = logging.FileHandler(logfilename, mode='a+')
file.setLevel(logging.DEBUG)

fileformat = logging.Formatter("%(asctime)s:[pid %(process)d]:%(levelname)s:%(message)s",datefmt="%H:%M:%S")
file.setFormatter(fileformat)

#handler for sending messages to console stdout
stream = logging.StreamHandler()
streamformat = logging.Formatter("%(asctime)s:%(filename)s:%(levelname)s:%(message)s",datefmt="%H:%M:%S")
stream.setLevel(logging.DEBUG)
stream.setFormatter(streamformat)

mylogs.addHandler(file)
#mylogs.addHandler(stream)

""" class Password(argparse.Action):
    def __call__(self, parser, namespace, values, option_string):
        if values is None:
            values = getpass.getpass()

        setattr(namespace, self.dest, values) """

parser = argparse.ArgumentParser()
parser = argparse.ArgumentParser(prog='PROG', formatter_class=argparse.RawDescriptionHelpFormatter, description=textwrap.dedent('''\
This Script patches a single system in SUSE Manager.

You need a suma_config.yaml file with login and email notification address.
If email notification will be used then you need to have mutt email client installed. 

Sample suma_config.yaml:
suma_host: mysumaserver.mydomain.local
suma_user: <USERNAME>
suma_password: <PASSWORD>
notify_email: <EMAIL_ADDRESS>

Sample command:
              python3.6 checkhosts.py --config suma_config.yaml --systemname mytestsystem.domain.local
              
              or 

              python3.6 checkhosts.py --config suma_config.yaml --systemname mytestsystem.domain.local --email
'''))

parser.add_argument("--config", help="enter the config file name that contains login information e.g. /root/suma_config.yaml",  required=False)
parser.add_argument("--systemname", help="Enter the system name you want to install all patches.",  required=True)
parser.add_argument("--email", help="use this option if you want email notifcation, the log file will be sent to it. The email address is provided in the suma_config.yaml",  action="store_true")
args = parser.parse_args()

def get_login(path):
    
    if path == "":
        path = os.path.join(os.environ["HOME"], "suma_config.yaml")
    with open(path) as f:
        login = yaml.load_all(f, Loader=yaml.FullLoader)
        for a in login:
            login = a

    return login

def login_suma(login):
    MANAGER_LOGIN = login['suma_user']
    MANAGER_PASSWORD = login['suma_password']
    SUMA = "http://" + login['suma_user'] + ":" + login['suma_password'] + "@" + login['suma_host'] + "/rpc/api"
    with ServerProxy(SUMA) as session_client:
        session_key = session_client.auth.login(MANAGER_LOGIN, MANAGER_PASSWORD)
    return session_client, session_key

def suma_logout(session, key):
    session.auth.logout(key)
    return

def result2email():
    if args.email:
        assert isfile(logfilename) and access(logfilename, R_OK), \
        "File {} doesn't exist or isn't readable".format(logfilename)
        email_client_name = "mutt"
        path_to_cmd = shutil.which(email_client_name)    
        if path_to_cmd is None:
            mylogs.error("[ERROR]: mutt email client is not installed.")
        else:
            mylogs.info("Sending log %s via email to %s" %(logfilename, suma_data["notify_email"]))
            subject = "SUSE Manager - Check Host status."
            cmd1 = ['cat', logfilename]
            proc1 = subprocess.run(cmd1, stdout=subprocess.PIPE)
            cmd2 = [email_client_name, '-s', subject, suma_data["notify_email"]]
            proc2 = subprocess.run(cmd2, input=proc1.stdout)
    else:
        mylogs.info("Not sending email.")
    return

def printdict(dict_object):
    mylogs.info("Item---------------------------------------------")
    for a, b in dict_object.items():
        if isinstance(b, dict):
            for k, v in b.items():
                print("{:<20}".format(k), "{:<20}".format(v))
        else:
            print("{:<20}".format(a), "{:<20}".format(b))
        
    mylogs.info("----------------------------------------------------")

def get_servers_patches(mylist):

    patch_list = {}
    temp_server_list = []
    for i, j in mylist.items():
        try:
            temp_list = session.system.getRelevantErrata(key, i)
            #mylogs.info("Host: %s    %d patches." %(j, len(temp_list)))
        except:
            mylogs.error("[ERROR]: failed to obtain patch list from %s" %(j))

        if temp_list and len(temp_list) != 0:
            patch_list[j] = len(temp_list)
        
    return patch_list

def isNotBlank(myString):
    if myString and myString.strip():
        #myString is not None AND myString is not empty or blank
        return True
    #myString is None OR myString is empty or blank
    return False

def patch_host(systemname):
    
    nowlater = datetime.datetime.now()
    earliest_occurrence = DateTime(nowlater)
    try:
        result_systemid = session.system.getId(key, systemname)
    except Exception as e:
        mylogs.error("[ERROR]: get systems id failed. %s" %(e))
        result2email()
        suma_logout(session, key)
        exit(1)
    mylogs.info("Systems is found.")

    if result_systemid:
        try:
            temp_list = session.system.getRelevantErrata(key, result_systemid[0]['id'])
            mylogs.info("Host: %s    %d patches." %(systemname, len(temp_list)))
        except:
            mylogs.error("[ERROR]: failed to obtain patch list from %s" %(systemname))
        if len(temp_list) > 0:
            patch_list = []
            server_id_list = []
            for p in temp_list:
                patch_list.append(p['id'])
            try:
                server_id_list.append(result_systemid[0]['id'])
                result_job = session.system.scheduleApplyErrata(key, server_id_list, patch_list, earliest_occurrence, True, True)
                mylogs.info("Jobs created %s" %(result_job[0]))
                print("Patch Job:")
                print("%s: %s" %(systemname, result_job[0]))
                print("[RESULT]:Param:JOB_ID=%s" %(result_job[0]))
            except Exception as e:
                mylogs.error("[ERROR]:scheduling job failed %s." %(e))
        else:
            print("Nothing to do.")
            mylogs.info("Nothing to install. Either already installed or channels not available to the systems.")
    return "finished."


if args.config:
    suma_data = get_login(args.config)
    session, key = login_suma(suma_data)
else:
    conf_file = "/root/suma_config.yaml"
    suma_data = get_login(conf_file)
    session, key = login_suma(suma_data)

if isNotBlank(args.systemname):
    result = patch_host(args.systemname)
    mylogs.info(result)
else:
    mylogs.info("systemname name is empty.")
    suma_logout(session, key)
    result2email()
    exit(1)
    
suma_logout(session, key)
result2email()