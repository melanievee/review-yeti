redis:  redis-server /usr/local/etc/redis.conf 
web:    bundle exec unicorn -p $PORT -c ./config/unicorn_dev.rb
worker: bundle exec sidekiq -c 25 -v