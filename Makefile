install:
	bundle install

start:
	rm -rf tmp/pids/server.pid
	bundle exec rails s -b '0.0.0.0' -p 5000
