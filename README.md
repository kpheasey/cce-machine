Crypto Currency Exchange Machine
===

After starting the application, sidekiq must be started.  All tickers are processed with background tasks in sidekiq.  ```bundle exec sidekiq```

Database must be PostgreSQL because of the notifications.

To get the most current data from all exchanges run ```bundle exec rake exchanges:tick```.  If you havent ticked in a while, this could take some time since tons of new data will be written.

There is a sidekiq daemon that will run on ubuntu 14.04 during a capistrano deployment.  Scheduler will start ticking every 1 minute.

## Streaming

Ticks will stream to the trading floor pages.  The stream is setup for a distributed or load balanced system.  So, each node runs ```/lib/daemons/trades_stream.rb```.  This listens for PostgreSQL notifications.  When a new notification is received, it publishes the data to a local Redis channel.  The ```TradeStreamController ``` uses ```ActionController::Live``` to listen to the redis channels and stream the data to the clients. This means that the database only has one open connection for each node and each node has an open connection for each users stream and the load is reduced on the database.

## Server Setup

Basic server setup needs 3 servers; application, datbase, ticker.  The ticker will be under non stop load since querying all the exchanges every minute is rather difficult.  Database can't reside with application because the database will also be pretty busy with the requests from ticker.  The application server can be the least powerful.
