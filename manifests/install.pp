# == Class: logstash_kafka::install
#
# This private class is meant to be called from `logstash_kafka`.
# It downloads and installs the logstash_kafka logstash plugin
#
class logstash_kafka::install
{

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
      package_url  => $logstash_kafka::logstash_package_url,
      java_install => false
    }
  }

  Class['java'] -> Class['kafka']
  Class['java'] -> Class['logstash']

  file { "${logstash_kafka::install_dir}-${logstash_kafka::version}":
    ensure => directory
  }

  exec { 'download-logstash-kafka':
    command => "/usr/bin/wget -O /tmp/logstash-kafka-v${logstash_kafka::version}.tar.gz https://codeload.github.com/joekiller/logstash-kafka/tar.gz/v${logstash_kafka::version}",
    unless  => "/usr/bin/test -f /tmp/logstash-kafka-v${logstash_kafka::version}.tar.gz"
  }

  exec { 'untar-logstash-kafka':
    command => "/bin/tar -xvzf /tmp/logstash-kafka-v${logstash_kafka::version}.tar.gz -C ${logstash_kafka::install_dir}-${logstash_kafka::version} --strip-components=1",
    unless  => "/usr/bin/test -d ${logstash_kafka::install_dir}-${logstash_kafka::version}/lib",
    require => [ File["${logstash_kafka::install_dir}-${logstash_kafka::version}"], Exec['download-logstash-kafka'] ]
  }

  exec { 'install-jruby-kafka':
    command     => "/usr/bin/java -jar vendor/jar/jruby-complete-1.7.11.jar --1.9 ${logstash_kafka::install_dir}/gembag.rb ${logstash_kafka::install_dir}/logstash-kafka.gemspec",
    cwd         => $logstash_kafka::logstash_install_dir,
    environment => 'GEM_HOME=vendor/bundle/jruby/1.9/ GEM_PATH= ',
    unless      => "/usr/bin/test -d ${logstash_kafka::logstash_install_dir}/vendor/bundle/jruby/1.9/gems/jruby-kafka-0.1.0"
  }

  file { $logstash_kafka::install_dir:
    ensure => link,
    target => "${logstash_kafka::install_dir}-${logstash_kafka::version}"
  }

  file { "${logstash_kafka::logstash_install_dir}/vendor/jar/kafka":
    ensure  => directory,
    require => Class['logstash']
  }

  file { "${logstash_kafka::logstash_install_dir}/vendor/jar/kafka/libs":
    ensure  => link,
    target  => "${logstash_kafka::kafka_install_dir}/libs",
    require => File["${logstash_kafka::logstash_install_dir}/vendor/jar/kafka"]
  }

#logstash::plugin
  file { "${logstash_kafka::logstash_install_dir}/lib/logstash/inputs/kafka.rb":
    ensure  => link,
    target  => "${logstash_kafka::install_dir}/lib/logstash/inputs/kafka.rb",
    require => Class['logstash']
  }

  file { "${logstash_kafka::logstash_install_dir}/lib/logstash/outputs/kafka.rb":
    ensure  => link,
    target  => "${logstash_kafka::install_dir}/lib/logstash/outputs/kafka.rb",
    require => Class['logstash']
  }
}
