module AMQP

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
  module Client

  end
end