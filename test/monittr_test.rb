require 'test_helper'

module Monittr

  class MonittrTest < Test::Unit::TestCase

    context "Monittr" do

      setup do
        @server = Server.new( fixture_file('status.xml') )
      end

      should "fetch info from Monit embedded web server" do
        assert_nothing_raised { Server.fetch }
        assert_nothing_raised { Server.fetch('http://admin:monit@localhost:2812/_status?format=xml') }
        assert_raise(FakeWeb::NetConnectNotAllowedError) { Server.fetch('http://example.com') }
      end

      should "return system info" do
        assert_not_nil     @server.system
        assert_equal 0,    @server.system.status
        assert_equal 1,    @server.system.monitored
        assert_equal 'myapplication.cz', @server.system.name
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
        assert_equal 15, @server.processes.size

        thin = @server.processes.first
        assert_not_nil thin
        assert_equal 0, thin.status
        assert_equal 1, thin.monitored
        assert_equal 1.2, thin.memory
        assert_equal 0.0, thin.cpu
      end

    end

  end

end
