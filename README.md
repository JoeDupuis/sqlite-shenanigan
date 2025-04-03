# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


RAILS_LOG_LEVEL=warn RUBY_YJIT_ENABLE=1 SECRET_KEY_BASE=asdf RAILS_ENV=production WEB_CONCURRENCY=20 RAILS_MAX_THREADS=3 bin/rails server
hey -c 128 -z 10s -m POST http://127.0.0.1:3000/requests
