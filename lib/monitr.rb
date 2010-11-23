require 'nokogiri'
require 'open-uri'
require 'ostruct'

module Monitr
  MONIT_URL = ENV['MONIT_URL'] || 'http://username:password@localhost:2812/_status?format=xml'

  class Monit

    attr_reader :xml, :system, :filesystems, :services

    def initialize
      @xml    = Nokogiri::HTML(open( MONIT_URL ))
      @system = Services::System.new(@xml.xpath("//service[@type=5]").first)
      @filesystems = @xml.xpath("//service[@type=0]").map { |xml| Services::Filesystem.new(xml) }
    end

  end


  module Services
    class Base < OpenStruct
      TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }
    end

    class System < Base
      def initialize(xml)
        super( { :name   => xml.xpath('name').first.content,
                 :status => xml.xpath('status').first.content.to_i,
                 :monitored => xml.xpath('monitor').first.content.to_i,
                 :load   => xml.xpath('system/load/avg01').first.content.to_f,
                 :cpu    => xml.xpath('system/cpu/user').first.content.to_f,
                 :memory => xml.xpath('system/memory/percent').first.content.to_f } )
      end
    end

    class Filesystem < Base
      def initialize(xml)
        super( { :name    => xml.xpath('name').first.content,
                 :status  => xml.xpath('status').first.content,
                 :monitored => xml.xpath('monitor').first.content.to_i,
                 :percent => xml.xpath('block/percent').first.content.to_f,
                 :usage   => xml.xpath('block/usage').first.content,
                 :total   => xml.xpath('block/total').first.content
              } )
      end
    end

  end

end
