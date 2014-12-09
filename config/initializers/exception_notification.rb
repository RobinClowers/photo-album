PhotoAlbum::Application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[PhotoAlbum Error] ",
    :sender_address => %{"PhotoAlbum Error Notifier" <errors@photos.robinclowers.com>},
    :exception_recipients => %w{robin.clowers@gmail.com}
  }
