#!/bin/bash

ev9_role="$1"
ev9_plat="$2"
p_manifest="/etc/puppetlabs/code/environments/production/manifests"
p_main="/etc/puppetlabs/code/environments/production"

echo -e "\n Details:: role=$ev9_role, platform=$ev9_plat \n"

fix_configs() {
  echo 'Setting nameserver to 8.8.8.8 for initial config:'
  echo nameserver 8.8.8.8 > /etc/resolv.conf

  echo "127.0.0.1 puppet" >> /etc/hosts

  echo "Fixing Paths :: "
  export PATH=$PATH:/opt/puppetlabs/bin:/usr/local/bin
  echo "export PATH=\$PATH:/opt/puppetlabs/bin:/usr/local/bin" >> /root/.bashrc
  echo "export PATH=\$PATH:/opt/puppetlabs/bin:/usr/local/bin" >> /home/vagrant/.bashrc

  echo "alias vi=\"vim\" " >> /root/.bashrc
  echo "alias vi=\"vim\" " >> /home/vagrant/.bashrc
}


# add all necessary packages
pkg_install() {
  echo 'Installing package dependencies'
  if [ ! -f /etc/yum.repos.d/epel.repo ]; then
    rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
  fi
  if [ ! -f /etc/yum.repos.d/puppetlabs-pc1.repo ]; then
    rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
  fi
  yum install -y yum-utils puppet-agent vim rubygems git wget curl
  yum update -y
  yum clean all
  yum makecache
  gem install hiera-eyaml
  gem install librarian-puppet
}

env_config() {
  cat > /etc/environment << EOF
FACTER_ev9_role=$ev9_role
FACTER_ev9_plat=$ev9_plat
EOF
}

librarian_update() {
  cd $p_main/ && librarian-puppet update --verbose
}

run_puppet() {
  export FACTER_ev9_role=$ev9_role
  export FACTER_ev9_plat=$ev9_plat

  echo "Executing puppet apply -v --show_diff $p_manifest"
  puppet apply -v --show_diff $p_manifest
  if [ $? -ge 4 ]; then
    exit 1
  fi
}

# check bootstrap status
if [ ! -f /etc/bootstrap_done ]; then
  echo 'Running bootstrap'
  fix_configs
  pkg_install
  env_config
  librarian_update
  touch /etc/bootstrap_done
else
  echo 'Skipping bootstrap steps -- already done ...'
fi

if [ ! -e $p_main/modules/tomcat ]; then
  echo -e '\n\nTomcat module check failed -- running librarian...\n\n'
  librarian_update
else
  echo -e '\n\nTomcat module check passed -- skipping Librarian run...\n'
fi

env_config
run_puppet
