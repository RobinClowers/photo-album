namespace :import do
  task :all_photos, [:path] => :environment do |t, args|
    require "album_set_processor"

    AlbumSetProcessor.new(args.path).syncronize_photos
  end

  task :photos, [:path] => :environment do |t, args|
    require "album_processor"

    AlbumProcessor.new(args.path).insert_all_photos
  end

  task :albums => :environment do
    require "album_set_processor"
    require 'yaml'

    root_path = "../photo-site-generator/source/albums/"
    index_filename = "index.markdown"
    paths = %w[
      bangkok
      chiang-mai
      don-det
      luang-prabang
      pai
      pakse-and-vientiane
      siem-reap
      slow-boat-to-thailand
      vang-vieng
    ]

    paths.each do |name|
      album_data = YAML.load_file(File.join(root_path, name, index_filename))
      photo = Photo.where(path: name, filename: album_data['cover']).first
      raise "can't find photo #{name}/#{album_data['cover']}" unless photo
      album = Album.where(title: album_data['title'].titleize).first_or_create
      album.update_attributes(cover_photo: photo)
    end
  end

end

