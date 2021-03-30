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
COMPRESSION_DAYS=10
DELETE_DAYS=30
XML_FILES_DELETE_DAYS=1

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
MAX_DOMAIN_DIR="/logs/MAXDEV_Domain/"
## OHS logs
##
OHS_DOMAIN_DIR="/logs/OHSDEV_Domain/"
## XML Files
##
XML_FILES_DIR="/logs/intglobaldir/xmlfiles/"
## MAXIMO Files
##
MAXIMO_FILES_DIR="/oracle/Domains/MAXDEV_Domain/maximo/logs/maximo/logs/"

###
### Log files to be compressed
###
###

## WEBLOGIC LOGS
## Comprimir logs posteriores a 60 dias
##
COMPRESS_MAXIMO_LOGS=`find $MAX_DOMAIN_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz | grep -v maximo | grep -v jmsServers`
## OHS LOGS
## Comprimir logs posteriores a 60 dias
##
COMPRESS_OHS_LOGS=`find $OHS_DOMAIN_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz`
## MAXIMO LOGS
##
##
COMPRESS_MX_LOGS=`find $MAXIMO_FILES_DIR -mtime +$COMPRESSION_DAYS -type f | grep -v .gz`


echo ""
echo ""  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"
echo "${red}@@@@@ ${yellow}Logs to compress ${red}@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@ ${yellow}Logs to compress ${red}@@@@@${reset}"
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"

if [[ $COMPRESS_MAXIMO_LOGS != "" ]]; then
        echo "${orange}The following WebLogic logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following WebLogic logs will be compressed:${reset}"
        echo $COMPRESS_MAXIMO_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_MAXIMO_LOGS
        gzip -f $COMPRESS_MAXIMO_LOGS
        else
        echo "${blue}There aren't WebLogic logs to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't WebLogic logs to be compressed${reset}"
fi

if [[ $COMPRESS_OHS_LOGS != "" ]]; then
        echo "${orange}The following OHS logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following OHS logs will be compressed:${reset}"
        echo $COMPRESS_OHS_LOGS  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_OHS_LOGS
        gzip -f $COMPRESS_OHS_LOGS
        else
        echo "${blue}There aren't OHS files to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't OHS files to be compressed${reset}"
fi

if [[ $COMPRESS_MX_LOGS != "" ]]; then
        echo "${orange}The following MAXIMO logs will be compressed:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following MAXIMO logs will be compressed:${reset}"
        echo $COMPRESS_MX_LOGS  >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $COMPRESS_MX_LOGS
        gzip -f $COMPRESS_MX_LOGS
        else
        echo "${blue}There aren't MAXIMO files to be compressed${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't MAXIMO files to be compressed${reset}"
fi


##
## Salto de linea / separador
##
echo "" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo ""


## WEBLOGIC LOGS
## Borrado de logs comprimidos con antiguedad de mas de 180 dias
##
DELETE_MAXIMO_LOGS=`find $MAX_DOMAIN_DIR -mtime +$DELETE_DAYS -type f | grep .gz | grep -v maximo | grep -v jmsServers`
## OHS LOGS
## Borrado de logs comprimidos con antiguedad de mas de 180 dias
##
DELETE_OHS_LOGS=`find $OHS_DOMAIN_DIR -mtime +$DELETE_DAYS -type f | grep .gz`
## xml files
## Borrado de ficheros generados por la interface EXTSYS1
##
DELETE_XML_FILES=`find $XML_FILES_DIR -mtime +$XML_FILES_DELETE_DAYS -type f`
## maximo logs
## Borrado de ficheros generados por maximo
##
DELETE_MX_LOGS=`find $MAXIMO_FILES_DIR -mtime +$DELETE_DAYS -type f | grep .gz`



echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"
echo "${red}@@@@@  ${yellow}Logs to delete  ${red}@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@  ${yellow}Logs to delete  ${red}@@@@@${reset}"
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo "${red}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${reset}"

if [[ $DELETE_MAXIMO_LOGS != "" ]]; then
        echo "${orange}The following WebLogic logs will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following WebLogic logs will be deleted:${reset}"
        echo $DELETE_MAXIMO_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_MAXIMO_LOGS
        rm -rf $DELETE_MAXIMO_LOGS
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
        echo "${blue}There aren't OHS log files to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't OHS log files to be deleted${reset}"
fi

if [[ $DELETE_XML_FILES != "" ]]; then
        echo "${orange}The following XML files will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following XML files will be deleted:${reset}"
        echo $DELETE_XML_FILES >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_XML_FILES
        rm -rf $DELETE_XML_FILES
        else
        echo "${blue}There aren't XML files to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't XML files to be deleted${reset}"
fi

if [[ $DELETE_MX_LOGS != "" ]]; then
        echo "${orange}The following MAXIMO logs will be deleted:${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${orange}The following MAXIMO logs will be deleted:${reset}"
        echo $DELETE_MX_LOGS >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo $DELETE_MX_LOGS
        rm -rf $DELETE_MX_LOGS
        else
        echo "${blue}There aren't MAXIMO logs to be deleted${reset}" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
        echo "${blue}There aren't MAXIMO logs to be deleted${reset}"
fi

##
## Salto de linea / separador
##
echo "" >> $CLEANUP_LOG/cleanup_$TIMESTAMP.log
echo ""

exit 0
