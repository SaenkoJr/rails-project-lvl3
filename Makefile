ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

install:
	bundle install

setup:
	bin/setup
	bin/rails db:fixtures:load

start:
	rm -rf tmp/pids/server.pid
	bundle exec rails s -b '0.0.0.0' -p 5000

lint:
	bundle exec rubocop

lint-fix:
	bundle exec rubocop --auto-correct

test:
	bin/rails test $(ARGS)

heroku-start:
	bundle exec heroku local

heroku-rails-console:
	heroku run rails console

.PHONY: test
