require 'nokogiri'
require 'rest-client'
require 'ostruct'

module Monitr

  # Represents one monitored system instance
  #
  class Server

    attr_reader :xml, :system, :filesystems, :processes

    def initialize(xml)
      @xml         = Nokogiri::XML(xml)
      @system      = Services::System.new(@xml.xpath("//service[@type=5]").first)
      @filesystems = @xml.xpath("//service[@type=0]").map { |xml| Services::Filesystem.new(xml) }
      @processes   = @xml.xpath("//service[@type=3]").map { |xml| Services::Process.new(xml) }
    end

    def self.fetch(url=nil)
      url = url || ENV['MONIT_URL'] || 'http://admin:monit@localhost:2812/_status?format=xml'
      self.new( RestClient.get(url) )
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
                 :load   => (xml.xpath('system/load/avg01').first.content.to_f rescue nil),
                 :cpu    => (xml.xpath('system/cpu/user').first.content.to_f rescue nil),
                 :memory => (xml.xpath('system/memory/percent').first.content.to_f rescue nil),
                 :uptime => (xml.xpath('//server/uptime').first.content.to_i rescue nil)
               } )
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

    class Process < Base
      def initialize(xml)
        super( { :name    => xml.xpath('name').first.content,
                 :status  => xml.xpath('status').first.content,
                 :monitored => xml.xpath('monitor').first.content.to_i,
                 :pid    => (xml.xpath('pid').first.content.to_i rescue nil),
                 :uptime => (xml.xpath('uptime').first.content.to_i rescue nil),
                 :memory => (xml.xpath('memory/percent').first.content.to_f rescue nil),
                 :cpu    => (xml.xpath('cpu/percent').first.content.to_f rescue nil)
          
               } )
      end
    end

  end

end
