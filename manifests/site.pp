# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

node /ubuntu/ {

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile',
  }

  host { 'localhost':
    ip => '127.0.0.1',
  }

  exec { 'update-apt-packages':
    command => '/usr/bin/apt-get update -y',
  }

  class { 'java':
    distribution => 'jre',
  }

  class { 'spark':
    master_hostname => 'localhost',
    yarn_enable => false,
  }

  include apt

  apt::source { 'CDH-5':
    comment  => 'Cloudera 5 repository',
    location => 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/',
    release  => 'trusty-cdh5.4.0',
    repos    =>  'contrib',
    key      => {
       'id'     => 'F36A89E33CC1BD0F71079007327574EE02A818DD',
       'source' => 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key'
    },
    include => {
      'src' => true,
      'deb' => true
    }
  } 

  include spark::master
  include spark::worker
  include spark::frontend

  Host['localhost'] -> File['bash_profile'] -> Exec['update-apt-packages'] -> Class['java'] -> Apt::Source['CDH-5'] -> Class['spark'] -> Class['spark::master'] -> Class['spark::worker'] -> Class['spark::frontend']

  # Configure TrueSight Pulse meter
  class { 'boundary':
    token => $::api_token,
  }

}

# Separate the Cento 7.0 install until the boundary meter puppet package is fixed
node /^centos-7-0/ {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile',
    before => Package['epel-release']
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    timeout => 1800
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages'],
    before => Class['docker']
  }

  class { 'docker':
    docker_users => ['vagrant'],
    tcp_bind => 'tcp://127.0.0.1:2375',
  }

  docker::image { 'ubuntu':
     image_tag => 'precise'
   }

  docker::run { 'helloworld':
     image => 'ubuntu',
     command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  }

}

node /^centos/ {

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile',
    before => Package['epel-release']
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    timeout => 1800
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages'],
    before => Class['docker']
  }

  class { 'docker':
    docker_users => ['vagrant'],
    tcp_bind => 'tcp://127.0.0.1:2375',
  }

  docker::image { 'ubuntu':
     image_tag => 'precise'
   }

  docker::run { 'helloworld':
     image => 'ubuntu',
     command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  }

  # Configure TrueSight Pulse meter
  class { 'boundary':
    token => $::api_token
  }

}


node default {

}
