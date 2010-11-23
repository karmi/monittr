require 'test_helper'

module Monitr

  class MonitrTest < Test::Unit::TestCase

    context "Monitr" do

      setup do
        @monit = Monit.new
      end

      should "return system info" do
        assert_not_nil     @monit.system
        assert_equal 'myapplication.cz', @monit.system.name
        assert_equal 5.28, @monit.system.load
        assert_equal 0,    @monit.system.status
      end

    end

  end

end
