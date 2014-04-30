# Puppet Master

## Overview

This module installs:

  * Puppet/Facter
  * Puppet Server
  * PuppetDB
  * Puppet Dashboard

These tools combine to provide a fully configured new Puppet Master server.

At the moment, many of the configuration parameters are hard-coded, I will
be re-factoring the code to use Hiera to contain the configuration and 
hopefully make it more maintainable.

## Usage

```
include puppet
include puppet::master
```

