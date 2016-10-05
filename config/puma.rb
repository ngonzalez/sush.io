# config/puma.rb

#
# bundle exec puma -p 3000 -C config/puma.rb

threads 8,32
workers 5
worker_timeout 15
preload_app!