# Vagrant Spark

Configures a virtual machine with a Spark Master and Spark Worker node running for testing TrueSight Pulse Plugin for Spark.

Spark package is installed from the Cloudera apt/yum repositories.

Master and Worker nodes will run automatically at system start-up. If you want to monitor an Application you can run the `spark-shell` command that exposes a WebUI on port 4040 to be monitored.

## Prerequistes

- Vagrant 1.72. or later, download [here](https://www.vagrantup.com/downloads.html)
- Virtual Box 4.3.26 or later, download [here](https://www.virtualbox.org/wiki/Downloads)
- git 1.7 or later

## Installation

Prior to installation you need to obtain in your Boundary API Token.

1. Clone the GitHub Repository:
```bash
$ git clone https://github.com/boundary/vagrant-spark
```

2. Start the virtual machine using your TrueSight Pulse API Token:
```bash
$ API_TOKEN=<TrueSight Pulse API Token> vagrant up <virtual machine name>
```
NOTE: Run `vagrant status` to list the name of the virtual machines.

3. Login to the virtual machine
```bash
$ vagrant ssh <virtual machine name>
```
