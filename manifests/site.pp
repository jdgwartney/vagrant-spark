# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

node /ubuntu/ {

  host { 'localhost':
    ip => '127.0.0.1',
  }  

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile',
    before => Class['docker']
  }

  exec { 'update-apt-packages':
    command => '/usr/bin/apt-get update -y',
  }

  class { 'docker':
    docker_users => ['vagrant'],
    tcp_bind => 'tcp://127.0.0.1:2375',
    version => $::docker_version,
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

