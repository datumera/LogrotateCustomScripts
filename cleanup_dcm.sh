#!/bin/bash
###
### Script developed by dAtUmErA
###


###
### Color definition
###
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 6`
yellow=`tput setaf 3`
orange=`tput setaf 131`
action=`tput setaf 132`
reset=`tput sgr0`

###
### Time range conditions / days
###
COMPRESSION_DAYS=90
DELETE_DAYS=180

##
## Define Date Timestamp
##
TIMESTAMP=`date +%Y%m%d_%H%M%S`

##
## Define a Log directory for the execution of this script 
##
CLEANUP_LOG="/oracle/scripts/crontab/cleanup_logs"

###
### Disallow parameters
###
if [[ $1 != "" ]]; then
	echo "${red}ERROR${reset}: El script $0 no permite el uso de argumentos"
	exit 1;
fi

###
### Grant execution only for weblogic user
### 
if [ $(whoami) != 'weblogic' ]; then
        echo "${red}ERROR${reset}: Debes utilizar el usuario weblogic para ejecutar el script $0"
        exit 1;
fi

###
### Validate / Create log directory 
###
if [ ! -d $CLEANUP_LOG ]; then
        mkdir -p $CLEANUP_LOG 
        echo "${yellow}INFO${reset}: Se ha generado el directorio $CLEANUP_LOG " >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${yellow}INFO${reset}: Se ha generado el directorio $CLEANUP_LOG " 
fi

###
### Definicion de Variables 
### Directorio logs WebLogic y directorio logs OHS 
###

##
## Directorio logs WebLogic 
##
DCM_DOMAIN_DIR="/oracle/Domains/DCM_Domain/servers/*/logs/"
##
## Directorio logs OHS
##
OHS_DOMAIN_DIR="/oracle/Middleware_WT11117/Oracle_WT1/instances/dcmtest/diagnostics/logs/OHS/ohs1/"

###
### Log files to be compressed
###
###

## WEBLOGIC LOGS
## Comprimir logs posteriores a 60 dias
##
COMPRESS_DCM_LOGS=`find $DCM_DOMAIN_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v proves | grep -v adr | grep -v .gz | grep -v jmsServers | grep -v dms | grep -v DMS | grep -v owsm | grep -v console | grep -v ohs`
COMPRESS_OHS_LOGS=`find $OHS_DOMAIN_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz | grep -v jmsServers | grep -v dms`

echo ""
echo ""  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" 
echo "${red}@@@@@ ${yellow}Logs to compress ${red}@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@ ${yellow}Logs to compress ${red}@@@@@${reset}"
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" 

if [[ $COMPRESS_DCM_LOGS != "" ]]; then 
	echo "${orange}The following WebLogic logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following WebLogic logs will be compressed:${reset}"
	echo $COMPRESS_DCM_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_DCM_LOGS 
	gzip -f $COMPRESS_DCM_LOGS
	else
	echo "${blue}There aren't WebLogic logs to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't WebLogic logs to be compressed${reset}"
fi

if [[ $COMPRESS_OHS_LOGS != "" ]]; then
        echo "${orange}The following OHS logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following OHS logs will be compressed:${reset}"
        echo $COMPRESS_OHS_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_OHS_LOGS
        gzip -f $COMPRESS_OHS_LOGS
        else
        echo "${blue}There aren't OHS logs to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't OHS logs to be compressed${reset}"
fi


##
## Salto de linea / separador
##
echo "" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo ""


## WEBLOGIC LOGS
## Borrado de logs comprimidos con antiguedad de mas de 180 dias
##
DELETE_DCM_LOGS=`find $DCM_DOMAIN_DIR -mtime +$DELETE_DAYS -type f | grep .gz | grep -v proves | grep logs | grep -v adr | grep -v jmsServers | grep -v dms | grep -v ohs`
## OHS LOGS
## Borrado de logs comprimidos con antiguedad de mas de 180 dias
##
DELETE_OHS_LOGS=`find $OHS_DOMAIN_DIR -mtime +$DELETE_DAYS -type f | grep .gz | grep -v jmsServers | grep -v dms`

echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" 
echo "${red}@@@@@  ${yellow}Logs to delete  ${red}@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@  ${yellow}Logs to delete  ${red}@@@@@${reset}"
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" 

if [[ $DELETE_DCM_LOGS != "" ]]; then
        echo "${orange}The following WebLogic logs will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following WebLogic logs will be deleted:${reset}" 
        echo $DELETE_DCM_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_DCM_LOGS 
        rm -rf $DELETE_DCM_LOGS
        else
        echo "${blue}There aren't WebLogic logs to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't WebLogic logs to be deleted${reset}"
fi

if [[ $DELETE_OHS_LOGS != "" ]]; then
        echo "${orange}The following OHS logs will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following OHS logs will be deleted:${reset}"
        echo $DELETE_OHS_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_OHS_LOGS
        rm -rf $DELETE_OHS_LOGS
        else
        echo "${blue}There aren't OHS logs to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't OHS logs to be deleted${reset}"
fi


##
## Salto de linea / separador
##
echo "" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "" 

exit 0
