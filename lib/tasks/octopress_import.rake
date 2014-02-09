require "album_set_processor"

namespace :import do
  task :all_photos, [:path] => :environment do |t, args|
    AlbumSetProcessor.new(args.path).syncronize_photos
  end

  task :albums => :environment do
    require 'yaml'

    root_path = "../photo-site-generator/source/albums/"
    index_filename = "index.markdown"
    paths = %w[
      bangkok/
      chiang-mai/
      don-det/
      luang-prabang/
      pai/
      pakse-and-vientiane/
      siem-reap/
      slow-boat-to-thailand/
      vang-vieng/
    ]

    paths.each do |name|
      album = YAML.load_file(Path.join(root_path, name, index_filename))
      photo = Photo.where(path: path, filename: album['cover']).first
      Album.create!(title: album['title'], cover_photo: photo)
    end
  end
end

