# Sush.io Demo App

Dependencies:
  - PostgreSQL (update config/database.yml)
  - GitHub Account with token (update config/initializers/config.rb)

Start Application in Development environment
```
  bundle exec puma -p 3000 -C config/puma.rb
```

Run tests (RSpec)
```
  bundle exec rspec
```
