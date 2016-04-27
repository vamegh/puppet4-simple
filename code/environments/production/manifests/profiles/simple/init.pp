class profiles::simple {
  class {'tomcat': }
  class {'nginx': }
  class {'hzm': }

  $install = hiera_hash('tomcat_install',{})
  if !empty($install) {
    create_resources('tomcat::install',
                     $install,
                     {notify => Tomcat::Service['hzm'],
                      before => Tomcat::Instance['hzm']})
  }

  $instances = hiera_hash('tomcat_instance',{})
  if !empty($instances) {
    create_resources('tomcat::instance',
                     $instances,
                     {notify => Tomcat::Service['hzm'],
                      before => Tomcat::Config::Server['hzm']})
  }

  $server = hiera_hash('tomcat_server',{})
  if !empty($server) {
    create_resources('tomcat::config::server',
                     $server,
                     {notify => Tomcat::Service['hzm']})
  }

  $war = hiera_hash('tomcat_war',{})
  if !empty($war) {
    create_resources('tomcat::war',
                     $war,
                     {notify => Tomcat::Service['hzm'],
                      require => Tomcat::Instance['hzm']})
  }

  $context = hiera_hash('tomcat_context',{})
  if !empty($context) {
    create_resources('tomcat::config::server::context',
                     $context,
                     {notify => Tomcat::Service['hzm'],
                      require => Tomcat::Config::Server['hzm']})
  }

  $service = hiera_hash('tomcat_service',{})
  if !empty($service) {
    create_resources('tomcat::service', $service)
  }

  $nginx_proxy = hiera_hash('nginx_proxy',{})
  if !empty($nginx_proxy) {
    create_resources('nginx::resource::vhost',
                     $nginx_proxy,
                     {notify => Class[nginx::service],
                      require => Tomcat::Config::Server['hzm']})
  }
}

