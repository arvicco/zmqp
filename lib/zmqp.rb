require 'version'

module ZMQP

  require "bundler/setup"
  Bundler.require :default

  # Requires ruby source file(s). Accepts either single filename/glob or Array of filenames/globs.
  # Accepts following options:
  # :*file*:: Lib(s) required relative to this file - defaults to __FILE__
  # :*dir*:: Required lib(s) located under this dir name - defaults to gem name
  #
  def self.require_libs(libs, opts={})
    file = Pathname.new(opts[:file] || __FILE__)
    [libs].flatten.each do |lib|
      name = file.dirname + (opts[:dir] || file.basename('.*')) + lib.gsub(/(?<!.rb)$/, '.rb')
      Pathname.glob(name.to_s).sort.each { |rb| require rb }
    end
  end
end # module ZMQP

require 'zmqmachine'

# Did I say that ZMQP is a drop-in replacement for AMQP?
AMQP = ZMQP unless defined? AMQP
EM = ZM unless defined? EM

# Require all ruby source files located under directory lib/zmqp
# If you need files in specific order, you should specify it here before the glob
ZMQP.require_libs %W[**/*]


module ZMQP

  class Error < StandardError; end

  # Defining class methods
  class << self
    @logging = false
    attr_accessor :logging
    attr_reader :conn, :closing
    alias :closing? :closing
    alias :connection :conn

    def connect *args
      Client.connect *args
    end

    def settings
      @settings ||= {
          # broker address
          :host => '127.0.0.1',
          :port => PORT,

          # login details
          :user => 'guest',
          :pass => 'guest',
          :vhost => '/',

          # connection timeout
          :timeout => nil,

          # logging
          :logging => false,

          # ssl
          :ssl => false
      }
    end

    # Must be called to startup the connection to lightweight service broker (was:the AMQP server).
    #
    # The method takes several arguments and an optional block.
    #
    # This takes any option that is also accepted by *??* ZMQMachine::connect.
    # Additionally, there are several ZMQP-specific options.
    #
    # * :user => String (default 'guest')
    # The username as defined by the AMQP server.
    # * :pass => String (default 'guest')
    # The password for the associated :user as defined by the AMQP server.
    # * :vhost => String (default '/')
    # The virtual host as defined by the AMQP server.
    # * :timeout => Numeric (default nil)
    # Measured in seconds.
    # * :logging => true | false (default false)
    # Toggle the extremely verbose logging of all protocol communications
    # between the client and the server. Extremely useful for debugging.
    #
    #  AMQP.start do
    #    # default is to connect to localhost:5672
    #
    #    # define queues, exchanges and bindings here.
    #    # also define all subscriptions and/or publishers
    #    # here.
    #
    #    # this block never exits unless EM.stop_event_loop
    #    # is called.
    #  end
    #
    # Most code will use the MQ api. Any calls to MQ.direct / MQ.fanout /
    # MQ.topic / MQ.queue will implicitly call #start. In those cases,
    # it is sufficient to put your code inside of an EventMachine.run
    # block. See the code examples in MQ for details.
    #
    def start *args, &blk
      ZM.run {
        @conn ||= connect *args
        @conn.callback(&blk) if blk
        @conn
      }
    end

    alias :run :start

    def stop
      if @conn and not @closing
        @closing = true
        @conn.close {
          yield if block_given?
          @conn = nil
          @closing = false
        }
      end
    end

    def client
      @client ||= BasicClient
    end

    def client= mod
      mod.__send__ :include, AMQP
      @client = mod
    end
  end
end

