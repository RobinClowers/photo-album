namespace :album do
  desc "Upload all photos in an album"
  task :upload, [:path] => :environment do |t, args|
    require 'uploader'

    slug = AlbumSlug.new(Pathname.new(args.path).basename.to_s)
    Uploader.new(slug).upload_all(args.path, :original)
  end
end
