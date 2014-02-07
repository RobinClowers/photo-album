namespace :import do
  task :albums => :environment do
    require 'yaml'

    paths = <<-END
      ../photo-site-generator/source/albums/bangkok/index.markdown
      ../photo-site-generator/source/albums/chiang-mai/index.markdown
      ../photo-site-generator/source/albums/don-det/index.markdown
      ../photo-site-generator/source/albums/index
      ../photo-site-generator/source/albums/index.markdown
      ../photo-site-generator/source/albums/luang-prabang/index.markdown
      ../photo-site-generator/source/albums/pai/index.markdown
      ../photo-site-generator/source/albums/pakse-and-vientiane/index.markdown
      ../photo-site-generator/source/albums/siem-reap/index.markdown
      ../photo-site-generator/source/albums/slow-boat-to-thailand/index.markdown
      ../photo-site-generator/source/albums/vang-vieng/index.markdown
    END

    files.each do |name|
      album = YAML.load_file(name)
      photo = Photo.find_by_filename(album[:cover])
      Album.create!(title: album[:title], cover_photo: photo)
    end
  end
end

