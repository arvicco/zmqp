by: Arvicco
url: http://github.com/arvicco/zmqp

Description
===========

[Asynchronous AMQP library](http://github.com/tmm1/amqp) sets a standard for messaging.
It is well documented and has clean and simple interfaces for most common messaging tasks.
However, it implements AMQP standard that has some serious
[problems and limitation](http://www.imatix.com/articles:whats-wrong-with-amqp).

[ZeroMQ](http://www.zeromq.org) offers a viable alternative to AMQP, as well as 3-10 times
performance boost for most common messaging tasks. However, its interfaces are very similar
to socket programming and look a bit frightening for the uninitiated.

This library wraps ZeroMQ/ZMQMachine with familiar interfaces that are equivalent to the ones
offered by [tmm1/amqp](http://github.com/tmm1/amqp). That way, you'll be able to leverage
your existing code developed for AMQP, getting additional benefits such as:

 * Performance boost (3-10 times for most common messaging tasks)
 * No broker-related bottlenecks for high-throughput applications
 * Ability to flexibly extend your messaging architecture
 * No external dependency on 3rd-party broker software (such as RabbitMQ)

Some library highlights/design choices:

 * ZMQP::Client/Connection is actually a connection to a lightweight service registry
 * All Exchanges are based on ZMQ sockets/devices
 * Queues can be omitted when binding to Exchanges, but if they are not omitted, they are based on ZMQ::Queue device
 * Socket complexity is mostly hidden from code by sane defaults, but more granular control is possible through options

Because ZMQ is inherently threaded, it does not make sense to use this library with
anything less than MRI 1.9.2, JRuby or Rubinius. MRI 1.9.1 may or may not work, MRI 1.8.7
and its below are broken beyond repair (as far as threading goes).

!!! Currently this library is at pre-alpha stage. Please do not use it for anything serious.

Getting started
===============

First things first, start with:

  $ gem install zmqp

Documentation
=============

To be added...

Credits
=======

(c) 2010 [Arvicco](http://github.com/arvicco)

This project was inspired by [tmm1/amqp](http://github.com/tmm1/amqp).
It is based on [ZMQMachine](http://github.com/chuckremes/zmqmachine).
Special thanks to Aman Gupta and Chuck Remes.

Resources
=========

 * [ZeroMQ](http://www.zeromq.org) (iMatix/FastMQ/Intel, C++, GPL3)

 * [Ruby bindings to ZeroMQ](http://github.com/chuckremes/ffi-rzmq)

 * [Learn ZeroMQ by Example](http://github.com/andrewvc/learn-ruby-zeromq)

 * Analysis of AMQP [problems](http://www.imatix.com/articles:whats-wrong-with-amqp)

 * ZeroMQ's [analysis of the messaging technology market](http://www.zeromq.org/whitepapers:market-analysis)

 * [A Critique of the Remote Procedure Call Paradigm](http://www.cs.vu.nl/~ast/publications/euteco-1988.pdf)

 * [A Note on Distributed Computing](http://research.sun.com/techrep/1994/smli_tr-94-29.pdf)

 * [Convenience Over Correctness](http://steve.vinoski.net/pdf/IEEE-Convenience_Over_Correctness.pdf)

 * [Metaprotocol Taxonomy and Communications Patterns](http://hessian.caucho.com/doc/metaprotocol-taxonomy.xtp)

 * Joe Armstrong on [Erlang messaging vs RPC](http://armstrongonsoftware.blogspot.com/2008/05/road-we-didnt-go-down.html)

License
=======
Copyright (c) 2010 Arvicco. See LICENSE for details.