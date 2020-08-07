class Albums
  def names
    if Rails.application.config.offline_dev
      local_folders
    else
      top_level_branches
    end
  end

  private

  def top_level_branches
    bucket.objects.map { |o| o.key.sub(/\/.*/, '') }.uniq
  end

  def local_folders
    Pathname.new("public/photos/").children.map(&:basename)
  end

  def bucket
    @bucket ||= Aws::S3::Bucket.new(Rails.application.config.bucket_name)
  end
end
