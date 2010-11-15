module ZMQP

  module BasicClient
    def process_frame frame
      if mq = channels[frame.channel]
        mq.process_frame(frame)
        return
      end

      case frame
        when Frame::Method
          case method = frame.payload
            when Protocol::Connection::Start
              send Protocol::Connection::StartOk.new({:platform => 'Ruby/EventMachine',
                                                      :product => 'AMQP',
                                                      :information => 'http://github.com/tmm1/amqp',
                                                      :version => VERSION},
                                                     'AMQPLAIN',
                                                     {:LOGIN => @settings[:user],
                                                      :PASSWORD => @settings[:pass]},
                                                     'en_US')

            when Protocol::Connection::Tune
              send Protocol::Connection::TuneOk.new(:channel_max => 0,
                                                    :frame_max => 131072,
                                                    :heartbeat => 0)

              send Protocol::Connection::Open.new(:virtual_host => @settings[:vhost],
                                                  :capabilities => '',
                                                  :insist => @settings[:insist])

            when Protocol::Connection::OpenOk
              succeed(self)

            when Protocol::Connection::Close
              # raise Error, "#{method.reply_text} in #{Protocol.classes[method.class_id].methods[method.method_id]}"
              STDERR.puts "#{method.reply_text} in #{Protocol.classes[method.class_id].methods[method.method_id]}"

            when Protocol::Connection::CloseOk
              @on_disconnect.call if @on_disconnect
          end
      end
    end
  end

  # ZMQP Client impersonates AMQP Client/Connection.
  # As such, it hides the difference between AMQP and ZMQ communication.
  # This means that the Client should be encapsulating all the knowledge about
  # ZMQ Sockets, socket handlers etc. It should probably do all the ZMQ "frame processing"
  # inside, accepting only raw sum/pub/pop/etc from MQ and feeding it back raw
  # data/exceptions
  #
  # Do we need Client at all? What is its role exactly?
  # Maybe MQ instance alone is enough to hide Z/A difference, and actual communication
  # will flow through "pseudo"-Exchanges and Queues anyway.
  #
  # Looks like Client is a Handler for Broker-connected socket?
  #
  module Client
    include ZM::Deferrable

    def initialize opts = {}
      @settings = opts
      extend ZMQP.client

      @broker_address = ZM::Address.new opts[:host], opts[:port], opts[:transport] || :tcp

      @on_disconnect ||= proc{ raise Error, "Could not connect to #{@broker_address}" }

      timeout @settings[:timeout] if @settings[:timeout]
      errback{ @on_disconnect.call } unless @reconnecting

      @connected = false

    end

    def self.connect opts = {}
      opts = ZMQP.settings.merge(opts)
      ZM.connect opts[:host], opts[:port], self, opts
      # What else do we need to connect to lightweight broker?
    end
  end
end