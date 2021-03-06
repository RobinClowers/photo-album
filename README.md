# Photo Album

### Setup

```bash
asdf install
brew install openssl postgresql imagemagick@6 jpegoptim
bundle config build.puma --with-opt-dir=/usr/local/opt/openssl
bundle
bundle exec rake db:setup
bundle exec rails server
cd client
yarn install
```

### Development

To run the rails server

```bash
bundle exec rails s
```

To run the nextjs client

```bash
bin/client-dev
```

To run the sidekiq server

```bash
bin/sidekiq-dev
```

To run in offline mode, run the server with

```bash
OFFLINE_DEV=true bundle exec rails s
```

Make sure you have downloaded the photos for any albums you want to work with,
and place them in `public/photos/<album_name>`. This can be done with the
following command:

```bash
aws s3 cp --recursive s3://robin-photos/<album_name>/ public/photos/<album_name>
```
