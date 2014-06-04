# == Class logstash_kafka::install
#
# This class is meant to be called from logstash_kafka
#
class logstash_kafka::install(
  $version = $logstash_kafka::version,
  $install_dir = $logstash_kafka::install_dir,
  $kafka_install_dir = $logstash_kafka::kafka_install_dir,
  $logstash_install_dir = $logstash_kafka::logstash_install_dir,
  $logstash_package_url = $logstash_kafka::logstash_package_url
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if !defined(Class['java']) {
    class { 'java':
      distribution => 'jdk'
    }
  }

  if !defined(Class['kafka']) {
    class { 'kafka':
      install_java => false
    }
  }

  if !defined(Class['logstash']) {
    class { 'logstash':
      package_url  => $logstash_package_url,
      java_install => false
    }
  }

  Class['java'] -> Class['kafka']
  Class['java'] -> Class['logstash']

  file { "${install_dir}-${version}":
    ensure => directory
  }

  exec { 'download-logstash-kafka':
    command => "/usr/bin/wget -O /tmp/logstash-kafka-v${version}.tar.gz https://codeload.github.com/joekiller/logstash-kafka/tar.gz/v${version}",
    unless  => "/usr/bin/test -f /tmp/logstash-kafka-v${version}.tar.gz"
  }

  exec { 'untar-logstash-kafka':
    command => "/bin/tar -xvzf /tmp/logstash-kafka-v${version}.tar.gz -C ${install_dir}-${version} --strip-components=1",
    unless  => "/usr/bin/test -d ${install_dir}-${version}/lib",
    require => [ File["${install_dir}-${version}"], Exec['download-logstash-kafka'] ]
  }

  exec { 'install-jruby-kafka':
    command     => "/usr/bin/java -jar vendor/jar/jruby-complete-1.7.11.jar --1.9 ${install_dir}/gembag.rb ${install_dir}/logstash-kafka.gemspec",
    cwd         => $logstash_install_dir,
    environment => 'GEM_HOME=vendor/bundle/jruby/1.9/ GEM_PATH= ',
    unless      => "/usr/bin/test -d ${logstash_install_dir}/vendor/bundle/jruby/1.9/gems/jruby-kafka-0.1.0"
  }

  file { $install_dir:
    ensure => link,
    target => "${install_dir}-${version}"
  }

  file { "${logstash_install_dir}/vendor/jar/kafka":
    ensure  => directory,
    require => Class['logstash']
  }

  file { "${logstash_install_dir}/vendor/jar/kafka/libs":
    ensure  => link,
    target  => "${kafka_install_dir}/libs",
    require => File["${logstash_install_dir}/vendor/jar/kafka"]
  }

#logstash::plugin
  file { "${logstash_install_dir}/lib/logstash/inputs/kafka.rb":
    ensure  => link,
    target  => "${install_dir}/lib/logstash/inputs/kafka.rb",
    require => Class['logstash']
  }

  file { "${logstash_install_dir}/lib/logstash/outputs/kafka.rb":
    ensure  => link,
    target  => "${install_dir}/lib/logstash/outputs/kafka.rb",
    require => Class['logstash']
  }
}
