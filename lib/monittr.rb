require 'nokogiri'
require 'rest-client'
require 'ostruct'

module Monittr

  class Cluster

    attr_reader :servers

    def initialize(urls=[])
      @servers = urls.map { |url| Server.fetch(url) }
    end

  end


  # Represents one monitored system instance
  #
  class Server

    attr_reader :xml, :system, :filesystems, :processes

    def initialize(xml)
      @xml         = Nokogiri::XML(xml)
      if error = @xml.xpath('error').first
        @system      = Services::Base.new :name    => error.attributes['name'].content,
                                          :message => error.attributes['message'].content,
                                          :status  => 3
      else
        @system      = Services::System.new(@xml.xpath("//service[@type=5]").first)
        @filesystems = @xml.xpath("//service[@type=0]").map { |xml| Services::Filesystem.new(xml) }
        @processes   = @xml.xpath("//service[@type=3]").map { |xml| Services::Process.new(xml) }
      end
    end

    def self.fetch(url=nil)
      url = url || ENV['MONIT_URL'] || 'http://admin:monit@localhost:2812/_status?format=xml'
      self.new( RestClient.get(url) )
    rescue Exception => e
      self.new(%Q|<error status="3" name="#{e.class}" message="#{e.message}" />|)
    end

    def inspect
      %Q|<#{self.class} name="#{system.name}" status="#{system.status}" message="#{system.message}">|
    end

  end


  module Services
    class Base < OpenStruct
      TYPES = { 0 => "Filesystem", 1 => "Directory", 2 => "File", 3 => "Daemon", 4 => "Connection", 5 => "System" }

      def value(matcher, converter=:to_s)
        @xml.xpath(matcher).first.content.send(converter) rescue nil
      end

      def inspect
        %Q|<#{self.class} name="#{name}" status="#{status}" message="#{message}">|
      end
    end

    class System < Base
      def initialize(xml)
        @xml = xml
        super( { :name      => value('name'                          ),
                 :status    => value('status',                  :to_i),
                 :monitored => value('monitor',                 :to_i),
                 :load      => value('system/load/avg01',       :to_f),
                 :cpu       => value('system/cpu/user',         :to_f),
                 :memory    => value('system/memory/percent',   :to_f),
                 :uptime    => value('//server/uptime',         :to_f)
               } )
      end
    end

    class Filesystem < Base
      def initialize(xml)
        @xml = xml
        super( { :name      => value('name'                          ),
                 :status    => value('status',                  :to_i),
                 :monitored => value('monitor',                 :to_i),
                 :percent   => value('block/percent',           :to_f),
                 :usage     => value('block/usage'                   ),
                 :total     => value('block/total'                   )
               } )
      rescue Exception => e
        puts "ERROR: #{e.class} -- #{e.message}, In: #{e.backtrace.first}"
       super( { :name => 'Error',
                :status  => 3,
                :message => e.message } )
      end
    end

    class Process < Base
      def initialize(xml)
        @xml = xml
        super( { :name      => value('name'                          ),
                 :status    => value('status',                  :to_i),
                 :monitored => value('monitor',                 :to_i),
                 :pid       => value('pid',                     :to_i),
                 :uptime    => value('uptime',                  :to_i),
                 :memory    => value('memory/percent',          :to_f),
                 :cpu       => value('cpu/percent',             :to_i)
          
               } )
       rescue Exception => e
         puts "ERROR: #{e.class} -- #{e.message}, In: #{e.backtrace.first}"
        super( { :name => 'Error',
                 :status  => 3,
                 :message => e.message } )
      end
    end

  end

end
