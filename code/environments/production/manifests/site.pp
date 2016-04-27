# sites.pp - Define the profiles
#

Exec { path => '/opt/puppetlabs/bin:/usr/bin:/usr/sbin/:/bin:/sbin' }

hiera_include('server-role')

node default { }

