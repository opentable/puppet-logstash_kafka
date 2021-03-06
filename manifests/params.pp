# == Class logstash_kafka::params
#
# This private class is meant to be called from logstash_kafka
# It sets variables according to platform
#
class logstash_kafka::params {
  $version = '0.5.1'
  $repository = 'https://codeload.github.com/joekiller/logstash-kafka/tar.gz'
  $jruby_kafka_version = '0.1.1'
  $install_dir = '/opt/logstash-kafka'
  $kafka_install_dir = '/opt/kafka'
  $logstash_install_dir = '/opt/logstash'
  $logstash_package_url = ''
}
