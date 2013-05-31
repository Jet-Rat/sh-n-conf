/usr/local/sbin/scripts/convert_recipients_raw.sh :

 21 # Edit EXCHANGE_HOST_IP and SHARE_NAME
 22 SMBSOURCE='//EXCHANGE_HOST_IP/SHARE_NAME'

 29 # Edit DOMAINNAME
 30 GREPPATTERN='DOMAINNAME'


/etc/postfix/main.cf

 30 # Edit GWHOSTNAME and DOMAINNAME
 31 myhostname = GWHOSTNAME.DOMAINNAME

 35 # Edit GWHOSTNAME and DOMAINNAME
 36 mydestination = GWHOSTNAME.DOMAINNAME, localhost.DOMAINNAME, localhost

 37 # Edit EXCHANGE_HOST_IP
 38 mynetworks = 127.0.0.0/8 EXCHANGE_HOST_IP [::ffff:127.0.0.0]/104 [::1]/128

 48 # Edit GWHOSTNAME and DOMAINNAME
 49 virtual_mailbox_domains = DOMAINNAME


/etc/postfix/helo

    # Edit DOMAINNAME
  3 /DOMAINNAME/i


/etc/postfix/transport

    # Edit DOMAINNAME and EXCHANGE_HOST_IP
  1 DOMAINNAME      smtp:[EXCHANGE_HOST_IP]


/etc/postfix/access

    # We want to get mail from this e-mail
  1 good_user@good_domain.yay               OK
    # And don't want to know anything about this
  2 bad_user@bad_domain.doh                 REJECT User is not available
    # Our users use intranet, so we can't realy get any mail to MailGW from our domain
  3 DOMAINNAME                              REJECT Your HELO could be better (You are me? R U sure?). Considered as SPAM!
    # And from our external IP
  4 WAN_IP                                  REJECT You have my IP? Great! Considered as SPAM!
    # Letter that has "localhost" in some of it attributes is likely spam
  5 localhost                               REJECT I dont write letters to myself. Considered as SPAM!
