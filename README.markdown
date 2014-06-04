####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with logstash_kafka](#setup)
    * [What logstash_kafka affects](#what-logstash_kafka-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with logstash_kafka](#beginning-with-logstash_kafka)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Install [logstash-kafka](https://github.com/joekiller/logstash-kafka) plugin to allow you to use kafka as a input/output to/from logstash  

[![Build
Status](https://secure.travis-ci.org/opentable/puppet-logstash_kafka.png)](https://secure.travis-ci.org/opentable/puppet-logstash_kafka.png)

##Module Description

The purpose of this module is to install the logstash-kafka plugin to logstash to enable it to be configured as a kafka consumer or producer.

##Setup

###What logstash_kafka affects

* Installation of the logstash-kafka plugin
* Adds new libraries into your existing logstash installation

###Beginning with logstash_kafka

Installing the logstash-kafka plugin to a custom logstash installation:

```puppet
   logstash { 'version 0.5.1':
     version              => '0.5.1',
     logstash_install_dir => '/opt/custom_logstash_dir'
   }
```


##Usage

###Classes and Defined Types

####Class: `logstash_kafka`

**Parameters within `logstash_kafka`:**
####`version`
The version of the the plugin to be installed.

####`install_dir`
The directory in which to install the plugin source

####`kafka_install_dir`
The directory of the kafka installation

####`logstash_install_dir`
The directory of the logstash installation

####`logstash_package_url`
If installing logstash at the same time as this plugin, the url to the logstash package


##Reference

###Classes
####Public Classes
* [`logstash_kafka`](#class-logstash_kafka): Guides the installation of the logstash-kafka plugin

##Limitations

This module is tested on the following platforms:

* CentOS 5
* CentOS 6
* Ubuntu 10.04.4
* Ubuntu 12.04.2
* Ubuntu 13.10

It is tested with the OSS version of Puppet only.

##Development

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.

###Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker](https://github.com/puppetlabs/beaker) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
	BEAKER_DEBUG=yes bundle exec rspec spec/acceptance

