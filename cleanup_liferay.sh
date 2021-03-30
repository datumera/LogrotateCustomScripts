#!/bin/bash
##
## Script developed by dAtUmErA
##


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
COMPRESSION_DAYS=60
DELETE_DAYS=180
DELETE_LIFERAY_TMP_DAYS=3

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
### Definición de Variables 
### Directorio logs WebLogic y directorio logs Liferay 
###

##
## Directorio logs WebLogic
##
WL_LOG_DIR="/oracle/share/Domains/lrtest/servers/lrtest01/logs/"
##
## Directorios logs Liferay
##
LIFERAY_LOG_DIR="/oracle/liferay_home/node1/logs/"
##
## Directorio temporales Liferay
##
LIFERAY_TMP_DIR="/oracle/liferay_home/node1/tmp/"
##
## Directorio logs OHS
##
OHS_DOMAIN_DIR="/oracle/Middleware_WT1036/Oracle_WT1/instances/lrtest1/diagnostics/logs/OHS/ohs1/"


###
### Log files to be compressed
###
###

## WEBLOGIC LOGS
## Comprimir logs posteriores a 60 dias
##
COMPRESS_WL_LOGS=`find $WL_LOG_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz | grep -v diagnostic_images | grep -v jmsServers`
## LIFERAY LOGS
## Comprimir logs posteriores a 60 dias
##
COMPRESS_LIFERAY_LOGS=`find $LIFERAY_LOG_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz | grep -v pedigri | grep -v portlet`
## OHS LOGS
## Comprimir logs posteriores al $COMPRESSION_DAYS value
##
COMPRESS_OHS_LOGS=`find $OHS_DOMAIN_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz | grep -v jmsServers | grep -v dms`

echo ""
echo ""  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" 
echo "${red}@@@@@ ${yellow}Logs to compress ${red}@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@ ${yellow}Logs to compress ${red}@@@@@${reset}"
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" 

if [[ $COMPRESS_WL_LOGS != "" ]]; then 
	echo "${orange}The following WebLogic logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following WebLogic logs will be compressed:${reset}"
	echo $COMPRESS_WL_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_WL_LOGS 
	gzip -f $COMPRESS_WL_LOGS
	else
	echo "${blue}There aren't WebLogic logs to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't WebLogic logs to be compressed${reset}"
fi

if [[ $COMPRESS_LIFERAY_LOGS != "" ]]; then
	echo "${orange}The following Liferay logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following Liferay logs will be compressed:${reset}"
	echo $COMPRESS_LIFERAY_LOGS  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_LIFERAY_LOGS 
        gzip -f $COMPRESS_LIFERAY_LOGS
        else
        echo "${blue}There aren't Liferay logs to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't Liferay logs to be compressed${reset}"
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
DELETE_WL_LOGS=`find $WL_LOG_DIR -mtime +$DELETE_DAYS -type f | grep .gz | grep -v diagnostic_images | grep -v jmsServers`
## LIFERAY LOGS
## Borrado de logs comprimidos con antiguedad de mas de 180 dias
##
DELETE_LIFERAY_LOGS=`find $LIFERAY_LOG_DIR -mtime +$DELETE_DAYS -type f | grep .gz | grep -v pedigri | grep -v portlet`
## LIFERAY TEMPORARY FILES 
## Borrado de los temporales de liferay generados tras importar desde STAGE
##
DELETE_LIFERAY_TMP_LAR=`find $LIFERAY_TMP_DIR -mtime +$DELETE_LIFERAY_TMP_DAYS -type f -name *.lar`
DELETE_LIFERAY_TMP_TMP=`find $LIFERAY_TMP_DIR -mtime +$DELETE_LIFERAY_TMP_DAYS -type f -name *.tmp`
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

if [[ $DELETE_WL_LOGS != "" ]]; then
        echo "${orange}The following WebLogic logs will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following WebLogic logs will be deleted:${reset}" 
        echo $DELETE_WL_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_WL_LOGS 
        rm -rf $DELETE_WL_LOGS
        else
        echo "${blue}There aren't WebLogic logs to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't WebLogic logs to be deleted${reset}"
fi

if [[ $DELETE_LIFERAY_LOGS != "" ]]; then
        echo "${orange}The following Liferay logs will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following Liferay logs will be deleted:${reset}"
        echo $DELETE_LIFERAY_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_LIFERAY_LOGS
        rm -rf $DELETE_LIFERAY_LOGS
        else
        echo "${blue}There aren't Liferay logs to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't Liferay logs to be deleted${reset}"
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

echo "" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo ""

echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"
echo "${red}@@@@@  ${yellow}Temporary files to delete  ${red}@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@  ${yellow}Temporary files to delete  ${red}@@@@@${reset}"
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"

if [[ $DELETE_LIFERAY_TMP_LAR != "" ]] || [[ $DELETE_LIFERAY_TMP_TMP != "" ]]; then
        echo "${orange}The following Liferay temporary files will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following Liferay temporary files will be deleted:${reset}"
        echo $DELETE_LIFERAY_TMP_LAR >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_LIFERAY_TMP_LAR
        echo $DELETE_LIFERAY_TMP_TMP >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_LIFERAY_TMP_TMP
        rm -rf $DELETE_LIFERAY_TMP_LAR
	rm -rf $DELETE_LIFERAY_TMP_TMP
        else
        echo "${blue}There aren't Liferay temporary files to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't Liferay temporary files to be deleted${reset}"
fi





##
## Salto de linea / separador
##
echo "" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "" 

exit 0