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

  include apt

  apt::source { 'CDH-5':
    comment  => 'Cloudera 5 repository',
    location => 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/',
    release  => 'trusty-cdh5.4.0',
    repos    =>  'contrib',
    architecture => 'amd64',
    key      => {
       'id'     => 'F36A89E33CC1BD0F71079007327574EE02A818DD',
       'source' => 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key'
    },
    include => {
      'src' => true,
      'deb' => true
    }
  } 

  service { 'spark-master':
    ensure => 'running'
  }

  service { 'spark-worker':
    ensure => 'running',
  }

  file { 'spark-master-config':
    path   => '/etc/init.d/spark-master',
    ensure => file,
    owner => 'root',
    source => '/vagrant/manifests/spark-master-ubuntu',
  }

  exec { 'spark-installation':
    environment => 'SPARK_CLASSPATH=/usr/share/java/slf4j-simple.jar',
    command => '/usr/bin/apt-get install -y spark-core spark-master spark-worker',
    timeout => 0,
  }
  
  file { 'spark-worker-config':
    path   => '/etc/init.d/spark-worker',
    ensure => file,
    owner => 'root',
    source => '/vagrant/manifests/spark-worker-ubuntu', 
  }
  # Configure TrueSight Pulse meter
  class { 'boundary':
    token => $::api_token,
  }

  Host['localhost'] -> File['bash_profile'] -> Exec['update-apt-packages'] -> Class['java'] -> Apt::Source['CDH-5'] -> Exec['spark-installation'] -> File['spark-master-config'] ~> Service['spark-master'] -> File['spark-worker-config'] ~> Service['spark-worker']
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
  }

  # Configure TrueSight Pulse meter
  class { 'boundary':
    token => $::api_token
  }

}


