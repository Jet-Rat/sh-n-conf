#!/bin/bash

##########################################
##	DESCRIPTION:
##########################################

#	This script converts output (list of mailboxes + some trash) from Exchange server into the list, usable by Postfix.

#	Exchange powershell script must include this:

#Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
#. $env:ExchangeInstallPath\bin\RemoteExchange.ps1
#Connect-ExchangeServer -auto
#
#Get-Mailbox | ft PrimarySMTPAddress > C:\scripts\mailscript_output\recipients_raw

##########################################
##	VARS:
##########################################

# Edit EXCHANGE_HOST_IP and SHARE_NAME
SMBSOURCE='//EXCHANGE_HOST_IP/SHARE_NAME'
MNTPOINT='/mnt/mailscript_output'
SMBCRED='/root/smb_mailscript_output.txt'

FROMFILE="${MNTPOINT}/recipients_raw"
TOFILE='/etc/postfix/recipients'

# Edit DOMAINNAME
GREPPATTERN='DOMAINNAME'

LOGFILE='/var/log/local/convert_recipients_raw.log'

##########################################
##	MAIN:
##########################################

echo -e "\n################\n$(date +%F_%T) : Convertation of raw recipients file STARTED" >> $LOGFILE

##	If source not mounted - trying to mount

if [[ "$(mount | grep "${MNTPOINT}")" == "" ]]; then
	echo "$(date +%F_%T) : Trying to mount smb-source" >> $LOGFILE
	mount -t cifs -o credentials=${SMBCRED} ${SMBSOURCE} ${MNTPOINT} && echo "$(date +%F_%T) : Mount SUCCESSFUL" >> $LOGFILE || echo "$(date +%F_%T) : Mount FAILED" >> $LOGFILE
fi;


##	If mount and file are ok - convert

if [[ "$(mount | grep "${MNTPOINT}")" != "" && -e $FROMFILE ]]; then
	echo "$(for i in $(iconv -f utf-16 -t utf-8 $FROMFILE | sed 's|.$||' | grep $GREPPATTERN | sort); do echo -e "${i}\tOK"; done)" > $TOFILE && echo "$(date +%F_%T) : Convertation SUCCESSFUL" >> $LOGFILE
	postmap $TOFILE && echo "$(date +%F_%T) : postmap SUCCESSFUL" >> $LOGFILE
	/etc/init.d/postfix restart && echo "$(date +%F_%T) : Postfix restarted SUCCESSFUL" >> $LOGFILE
	exit 0;
fi;


##	If smth goes wrong - log it

echo "$(date +%F_%T) : Convertation FAILED" >> $LOGFILE
exit 1;
