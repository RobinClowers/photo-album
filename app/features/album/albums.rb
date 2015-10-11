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
    bucket.as_tree.children.select(&:branch?).map(&:prefix)
      .map { |prefix| prefix.gsub('/', '') }
  end

  def local_folders
    Pathname.new("public/photos/").children.map(&:basename)
  end

  def s3
    @s3 ||= AWS::S3.new
  end

  def bucket
    @bucket ||= s3.buckets[Rails.application.config.bucket_name]
  end
end
