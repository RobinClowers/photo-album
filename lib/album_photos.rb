class AlbumPhotos
  attr_accessor :title

  def initialize(title)
    @title = title
  end

  def original
    keys(:original)
  end

  def thumb
    keys(:thumb)
  end

  def web
    keys
  end

  def create(name, image_path, type: :web)
    raise 'invalid type' unless [:web, :thumb, :original].include? type.to_sym
    key_to_create = key(type, name)
    puts "creating #{key_to_create} from #{image_path}"
    bucket.objects.create(key_to_create, file: image_path)
  end

  private

  def keys(type)
    tree = bucket.as_tree(prefix: prefix(type))
    tree.children.select(&:leaf?).map(&:key)
  end

  def key(type, name)
    [title, prefix(type)].compact.join('/')
  end

  def prefix(type)
    return nil if type == :web
    type
  end

  def s3
    @s3 ||= AWS::S3.new
  end

  def bucket
    @bucket ||= s3.buckets['robin-photos']
  end
end
