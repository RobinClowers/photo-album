namespace :import do
  # usage rake import:all_photos['~/Pictures']
  task :all_photos, [:path] => :environment do |t, args|
    require "album_set_processor"

    AlbumSetProcessor.new(args.path).syncronize_photos
  end

  # usage rake import:photos['~/Pictures/Hawaii']
  task :photos, [:path] => :environment do |t, args|
    require "album_processor"

    AlbumCreator.new(args.path).insert_all_photos
  end
end

