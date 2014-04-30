# Puppet Master

## Overview

This repository creates a master/agent setup.  The master includes:

  * Puppet
  * Facter
  * Apache Web Server
  * PuppetDB
  * Puppet Dashboard

The point of this repository is to get a developer setup with a Puppet
master/agent setup quickly.  I've used Vagrant (http://www.vagrantup.com/) to 
setup 2 VMs, one configured as the master, the other as an agent.  This
will be expanded upon to add the actual nodes required, the puppetagent
node is just there as an example and to test the Puppet Master.


## Usage

See ```$PUPPET_MASTER/manifests/site.pp``` on how to setup a master
and one or more agents.
