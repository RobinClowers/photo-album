# Photo Album

### Setup

```bash
asdf install
brew install openssl postgresql imagemagick@6
bundle config build.puma --with-opt-dir=/usr/local/opt/openssl
bundle
bundle exec rake db:setup
bundle exec rails server
```

### Development

To run the rails server

```bash
bundle exec rails s
```

To run the sidekiq server

```bash
bundle exec sidekiq -q web -q utility
```
