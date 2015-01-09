class Albums
  def names
    top_level_branches.map(&:prefix).map { |prefix| prefix.gsub('/', '') }
  end

  private

  def top_level_branches
    bucket.as_tree.children.select(&:branch?)
  end

  def s3
    @s3 ||= AWS::S3.new
  end

  def bucket
    @bucket ||= s3.buckets[Rails.Application.config.bucket_name]
  end
end
