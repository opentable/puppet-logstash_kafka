# Author::    Liam Bennett  (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class: logstash_kafka
#
# The purpose of this module is to install the logstash-kafka plugin to logstash to enable it to be configured as a kafka consumer or producer.
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*version*]
#   The version of the the plugin to be installed.
# [*jruby_kafka_version*]
# [*install_dir]
#   The directory in which to install the plugin source
#
# [*kafka_install_dir*]
#   The directory of the kafka installation
#
# [*logstash_install_dir*]
#   The directory of the logstash installation
#
# [*logstash_package_url*]
#   If installing logstash at the same time as this plugin, the url to the logstash package
#
# === Examples
#
#
class logstash_kafka(
  $version = $logstash_kafka::params::version,
  $jruby_kafka_version = $logstash_kafka::params::jruby_kafka_version,
  $install_dir = $logstash_kafka::params::install_dir,
  $kafka_install_dir = $logstash_kafka::params::kafka_install_dir,
  $logstash_install_dir = $logstash_kafka::params::logstash_install_dir,
  $logstash_package_url = $logstash_kafka::params::logstash_package_url
) inherits logstash_kafka::params {

  validate_re($version,'^\d+\.\d+\.?\d*$',"${version} is not a valid semver version")
  validate_absolute_path($install_dir)
  validate_absolute_path($kafka_install_dir)
  validate_absolute_path($logstash_install_dir)


  class { 'logstash_kafka::install': } ->
  Class['logstash_kafka']
}
