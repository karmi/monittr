require 'test_helper'

module Monittr

  class MonittrTest < Test::Unit::TestCase

    context "Cluster" do

      should "be initialized with URLs" do
        assert_nothing_raised do
          cluster = Monittr::Cluster.new %w[ http://admin:monit@localhost:2812
                                             http://admin:monit@localhost:2812 ]
          assert_not_nil cluster.servers
          assert_equal 2, cluster.servers.size
        end
      end

      should "not fail on invalid URLS" do
        assert_nothing_raised do
          cluster = Monittr::Cluster.new %w[ ~INVALID
                                             http://admin:monit@localhost:2812 ]
          assert_not_nil cluster.servers
          assert_equal 2, cluster.servers.size
          assert_equal 3, cluster.servers.first.system.status
          assert cluster.servers.first.system.message =~ /bad hostname/, "Should be bad hostname"
          assert_not_nil cluster.servers.first.filesystems
          assert_equal [], cluster.servers.first.filesystems
        end
      end

      should "not fail on out-of-order URLs" do
        cluster = Monittr::Cluster.new %w[ http://not-working
                                           http://admin:monit@localhost:2812 ]
        assert_not_nil cluster.servers
        assert_equal 2, cluster.servers.size
        assert_equal 3, cluster.servers.first.system.status
        assert_equal '500 Internal Server Error', cluster.servers.first.system.message
      end

      should "timeout properly for non-responding URLs" do
        cluster = Monittr::Cluster.new %w[ http://admin@timeout.net:2812 ]
        assert_not_nil cluster.servers
        assert_equal 1, cluster.servers.size
        assert_equal 3, cluster.servers.first.system.status
        assert_equal 'RestClient::RequestTimeout', cluster.servers.first.system.name
      end

    end

    context "Server" do

      setup do
        @server = Server.new( 'http://localhost:2812', fixture_file('status.xml') )
      end

      should "parse error XML on initialization" do
        assert_nothing_raised do
          server = Server.new 'http://example.com', %Q|<error status="3" name="ERROR" message="MESSAGE" />|
          assert_equal 'ERROR', server.system.name
        end
      end

      should "fetch info from Monit embedded web server" do
        assert_nothing_raised { Server.fetch }
        assert_nothing_raised { Server.fetch('http://admin:monit@localhost:2812') }
        assert_nothing_raised { Server.fetch('http://admin:monit@localhost:2812/') }
      end

      should "return the URL" do
        server = Server.fetch('http://admin:monit@localhost:2812')
        assert_equal 'http://admin:monit@localhost:2812', server.url
      end

      should "return system info" do
        assert_not_nil     @server.system
        assert_equal 0,    @server.system.status
        assert_equal 1,    @server.system.monitored
        assert_equal 'application.com', @server.system.name
        assert_equal 5.28, @server.system.load
        assert_equal 0,    @server.system.status
        assert_equal 937661, @server.system.uptime
      end

      should "return filesystems info" do
        assert_not_nil @server.filesystems
        assert_equal 4, @server.filesystems.size

        filesystem = @server.filesystems.first
        assert_not_nil filesystem
        assert_equal 0, filesystem.status
        assert_equal 1, filesystem.monitored
        assert_equal 22.8, filesystem.percent
      end

      should "return processes info" do
        assert_not_nil @server.processes
        assert_equal 13, @server.processes.size

        thin = @server.processes.first
        assert_not_nil thin
        assert_equal 0, thin.status
        assert_equal 1, thin.monitored
        assert_equal 1.2, thin.memory
        assert_equal 0.0, thin.cpu
      end

      should "return hosts info" do
        assert_not_nil @server.hosts
        assert_equal 1, @server.hosts.size

        assert_equal 'www.google.com', @server.hosts[0].name
        assert_equal 0, @server.hosts[0].status
        assert_equal 1, @server.hosts[0].monitored
        assert_equal '0.009', @server.hosts[0].response_time
      end

    end

    [ Services::System, Services::Filesystem, Services::Process ].each do |klass|
      context "#{klass}" do
        should "deal with invalid XML" do        
          assert_nothing_raised do
            part = klass.new('KRUPITZOWKA')
            assert_nil part.name
          end
        end
      end
    end


    # ---------------------------------------------------------------------------

  end

end
