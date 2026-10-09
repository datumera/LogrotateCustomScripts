
===============================================================================
              ORACLE MIDDLEWARE & APPLICATION LOG CLEANUP SCRIPTS
===============================================================================

Script Suite : cleanup_dcm.sh, cleanup_liferay.sh, cleanup_maximo.sh
Author       : dAtUmErA
Description  : Automates log rotation, gzip compression, and retention cleanup
               for Oracle WebLogic Server, Oracle HTTP Server (OHS), Liferay
               Portal, and IBM Maximo Asset Management.

===============================================================================
1. OVERVIEW
===============================================================================

Application servers generate large volumes of diagnostic logs, trace files, and
temporary artifacts over time. These scripts automatically scan target domain
directories, compress old log files using gzip to save disk space, and purge
expired archives and temporary export files based on defined retention thresholds.

===============================================================================
2. REPOSITORY STRUCTURE
===============================================================================

Script File        Target Platform           Description
-------------------------------------------------------------------------------
cleanup_dcm.sh     WebLogic (DCM) & OHS      Handles compression and purging
                                             of DCM domain and OHS web server
                                             logs.

cleanup_liferay.sh WebLogic, Liferay & OHS   Manages Liferay portal logs,
                                             staging temp files (.lar, .tmp),
                                             and associated OHS/WebLogic logs.

cleanup_maximo.sh  WebLogic, Maximo & OHS    Automates cleanup for Maximo
                                             application logs, integration XML
                                             interface files, and OHS logs.

===============================================================================
3. KEY FEATURES & COMMON BEHAVIORS
===============================================================================

* User Execution Enforcement : All scripts strictly require execution by the
                               'weblogic' system user.
* No Arguments Allowed       : Scripts run without command-line parameters to
                               ensure safe execution in automated jobs.
* Execution Logging          : Outputs step-by-step progress to terminal with
                               ANSI color formatting and writes detailed log
                               files to /oracle/scripts/crontab/cleanup_logs/
* Selective Pattern Filtering: Uses find coupled with grep exclusions to
                               protect critical files (active .gz archives,
                               JMS servers, diagnostic images) from
                               accidental deletion or double-compression.

===============================================================================
4. RETENTION POLICIES SUMMARY
===============================================================================

Script             Log / File Type                Compress       Delete
-------------------------------------------------------------------------------
cleanup_dcm.sh     WebLogic DCM & OHS Logs        > 90 days      > 180 days

cleanup_liferay.sh WebLogic, Liferay & OHS Logs   > 60 days      > 180 days
                   Liferay Staging Temp Files     N/A            > 3 days

cleanup_maximo.sh  WebLogic, Maximo & OHS Logs    > 10 days      > 30 days
                   Interface XML Files (EXTSYS1)  N/A            > 1 day

===============================================================================
5. CONFIGURATION PATHS
===============================================================================

[A] DCM Cleanup (cleanup_dcm.sh):
    - WebLogic Logs : /oracle/Domains/DCM_Domain/servers/*/logs/
    - OHS Logs      : /oracle/Middleware_WT11117/Oracle_WT1/instances/dcmtest/
                      diagnostics/logs/OHS/ohs1/

[B] Liferay Cleanup (cleanup_liferay.sh):
    - WebLogic Logs : /oracle/share/Domains/lrtest/servers/lrtest01/logs/
    - Liferay Logs  : /oracle/liferay_home/node1/logs/
    - Liferay Temp  : /oracle/liferay_home/node1/tmp/
    - OHS Logs      : /oracle/Middleware_WT1036/Oracle_WT1/instances/lrtest1/
                      diagnostics/logs/OHS/ohs1/

[C] Maximo Cleanup (cleanup_maximo.sh):
    - WebLogic Logs : /logs/MAXDEV_Domain/
    - OHS Logs      : /logs/OHSDEV_Domain/
    - Maximo Logs   : /oracle/Domains/MAXDEV_Domain/maximo/logs/maximo/logs/
    - XML Interface : /logs/intglobaldir/xmlfiles/

===============================================================================
6. PREREQUISITES
===============================================================================

- OS                  : Enterprise Linux (RHEL / Oracle Linux)
- System User         : weblogic
- Required Utilities  : bash, gzip, find, grep, tput

===============================================================================
7. USAGE & AUTOMATION
===============================================================================

[A] Manual Execution:

    $ chmod +x cleanup_dcm.sh cleanup_liferay.sh cleanup_maximo.sh
    $ ./cleanup_dcm.sh

[B] Crontab Setup (weblogic user):

    0 2 * * * /oracle/scripts/crontab/cleanup_dcm.sh > /dev/null 2>&1
    0 3 * * * /oracle/scripts/crontab/cleanup_liferay.sh > /dev/null 2>&1
    0 4 * * * /oracle/scripts/crontab/cleanup_maximo.sh > /dev/null 2>&1

===============================================================================

```
