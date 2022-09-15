#!/bin/bash
# Title: Validate Sybase Update.

#/usr/sap/hostctrl/exe/Sybase_update_check.sh $[SAPDBNAME:#required] $[PARAM-updatedir:#required]

SAPDBNAME=$1
DROP_LOCATION=$2

echo "/usr/sap/hostctrl/exe/saphostctrl -function LiveDatabaseUpdate -dbname $SAPDBNAME -dbtype syb -updateoption TASK=VALIDATE_SEC_STORES"
if /usr/sap/hostctrl/exe/saphostctrl -function LiveDatabaseUpdate -dbname $SAPDBNAME -dbtype syb -updateoption TASK=VALIDATE_SEC_STORES | grep -i TASK_STATUS=OK; then
	echo "[RESULT]: TASK VALIDATE_SEC_STORES OK";
else
	echo "[ERROR]: TASK VALIDATE_SEC_STORES NOK"
	echo "Check Logfile: /usr/sap/hostctrl/work/LiveUpdate.log"
exit 1;
fi 
echo ""
echo "/usr/sap/hostctrl/exe/saphostctrl -function LiveDatabaseUpdate -dbname $SAPDBNAME -dbtype syb -updatemethod Execute -updateoption TASK=CHECK_UPDATE_ASE -updateoption DROP_LOCATION=$DROP_LOCATION"
if /usr/sap/hostctrl/exe/saphostctrl -function LiveDatabaseUpdate -dbname $SAPDBNAME -dbtype syb -updatemethod Execute -updateoption TASK=CHECK_UPDATE_ASE -updateoption DROP_LOCATION=$DROP_LOCATION | grep -i CHECK_UPDATE_ASE=OK; then
	echo "[RESULT]: TASK CHECK_UPDATE_ASE OK";
else
	echo "[ERROR]: TASK CHECK_UPDATE_ASE NOK"
	echo "Check Logfile: /usr/sap/hostctrl/work/LiveUpdate.log"
exit 1;
fi

exit 0

