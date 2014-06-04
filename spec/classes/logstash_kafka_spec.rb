require 'spec_helper'

describe 'logstash_kafka' do
  context 'supported operating systems' do

    describe "logstash_kafka class without any parameters on Debian" do
      let(:params) {{ }}
      let(:facts) {{
          :kernel          => 'Linux',
          :osfamily        => 'Debian',
          :operatingsystem => 'Ubuntu',
          :lsbdistcodename => 'trusty'
      }}

      #it { should compile.with_all_deps }

      it { should contain_class('logstash_kafka::install') }

      it { should contain_class('kafka') }
      it { should contain_class('logstash') }
      it { should contain_class('java').that_comes_before('kafka') }
      it { should contain_class('java').that_comes_before('logstash') }

      it { should contain_file('/opt/logstash-kafka-0.5.1').with('ensure' => 'directory') }
      it { should contain_file('/opt/logstash-kafka').with('ensure' => 'link') }

      it { should contain_exec('download-logstash-kafka') }
      it { should contain_exec('untar-logstash-kafka') }
      it { should contain_exec('install-jruby-kafka') }

      it { should contain_file('/opt/logstash/vendor/jar/kafka').with('ensure' => 'directory') }
      it { should contain_file('/opt/logstash/vendor/jar/kafka/libs').with('ensure' => 'link') }
      it { should contain_file('/opt/logstash/lib/logstash/inputs/kafka.rb').with('ensure' => 'link') }
      it { should contain_file('/opt/logstash/lib/logstash/outputs/kafka.rb').with('ensure' => 'link') }
    end

    describe "logstash_kafka class without any parameters on RedHat" do
      let(:params) {{ }}
      let(:facts) {{
          :kernel          => 'Linux',
          :osfamily        => 'RedHat',
          :operatingsystem => 'CentOS'
      }}

      #it { should compile.with_all_deps }

      it { should contain_class('logstash_kafka::install') }

      it { should contain_class('kafka') }
      it { should contain_class('logstash') }
      it { should contain_class('java').that_comes_before('kafka') }
      it { should contain_class('java').that_comes_before('logstash') }

      it { should contain_file('/opt/logstash-kafka-0.5.1').with('ensure' => 'directory') }
      it { should contain_file('/opt/logstash-kafka').with('ensure' => 'link') }

      it { should contain_exec('download-logstash-kafka') }
      it { should contain_exec('untar-logstash-kafka') }
      it { should contain_exec('install-jruby-kafka') }

      it { should contain_file('/opt/logstash/vendor/jar/kafka').with('ensure' => 'directory') }
      it { should contain_file('/opt/logstash/vendor/jar/kafka/libs').with('ensure' => 'link') }
      it { should contain_file('/opt/logstash/lib/logstash/inputs/kafka.rb').with('ensure' => 'link') }
      it { should contain_file('/opt/logstash/lib/logstash/outputs/kafka.rb').with('ensure' => 'link') }
    end

  end

  context 'unsupported operating system' do
    describe 'logstash_kafka class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('logstash_kafka') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
