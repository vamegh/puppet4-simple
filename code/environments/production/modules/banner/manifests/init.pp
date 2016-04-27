# Displays information banner
class banner {
  $label_env = sprintf('%-70s',"Environment: ${environment}")
  $label_fqdn = sprintf('%-70s',"FQDN: ${fqdn}")
  $label_role = sprintf('%-70s',"Role: ${ev9_role}")

  $banner = "
######################## Welcome  ##########################
#                                                          #
# ${label_env}                                             #
#                                                          #
# ${label_fqdn}                                            #
#                                                          #
# ${label_role}                                            #
#                                                          #
############################################################

***************************************************************************
                            NOTICE TO USERS


This computer system is the private property of ev9, whether
individual, corporate or government.  It is for authorized use only.
Users (authorized or unauthorized) have no explicit or implicit
expectation of privacy.

Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and
disclosed to your employer, to authorized site, government, and law
enforcement personnel, as well as authorized officials of government
agencies, both domestic and foreign.

By using this system, the user consents to such interception, monitoring,
recording, copying, auditing, inspection, and disclosure at the
discretion of such personnel or officials.  Unauthorized or improper use
of this system may result in civil and criminal penalties and
administrative or disciplinary action, as appropriate. By continuing to use
this system you indicate your awareness of and consent to these terms
and conditions of use. LOG OFF IMMEDIATELY if you do not agree to the
conditions stated in this warning.

****************************************************************************

"

  file { '/etc/motd':
    ensure  => file,
    content => $banner,
    mode    => '0644',
    owner   => 'root',
    group   => 'root'
  }
}
