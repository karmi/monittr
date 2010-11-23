require 'test_helper'

module Monitr

  class MonitrTest < Test::Unit::TestCase

    context "Monitr" do

      setup do
        @monit = Monit.new
      end

      should "return system info" do
        assert_not_nil     @monit.system
        assert_equal 1,    @monit.system.monitored
        assert_equal 'myapplication.cz', @monit.system.name
        assert_equal 5.28, @monit.system.load
        assert_equal 0,    @monit.system.status
      end

      should "return filesystems info" do
        assert_not_nil @monit.filesystems
        assert_equal 4, @monit.filesystems.size
        filesystem = @monit.filesystems.first
        assert_not_nil filesystem
        assert_equal 1, filesystem.monitored
        assert_equal 22.8, filesystem.percent
      end

    end

  end

end
