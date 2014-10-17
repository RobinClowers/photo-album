class AlbumPhotos
  attr_accessor :title

  def initialize(title)
    @title = title
  end

  def original
    keys(:original)
  end

  def thumbs
    keys(:thumbs)
  end

  def web
    keys
  end

  def keys(type)
    leaf_nodes(type).map(&:key).map { |key| Pathname.new(key).basename.to_s }
  end

  def create(name, image_path, type: :web)
    raise 'invalid type' unless [:web, :thumbs, :original].include? type.to_sym
    key_to_create = key(type, name)
    puts "creating #{key_to_create} from #{image_path}"
    bucket.objects.create(key_to_create, file: image_path)
  end

  def download_original(target_dir)
    FileUtils.mkdir_p(target_dir)
    leaf_nodes(:original).map(&:object).each do |object|
      download(object, target_dir)
    end
  end

  private

  def download(object, target_dir)
    filename = Pathname.new(object.key).basename
    filepath = "#{target_dir}/#{filename}"
    return if File.exist? filepath

    puts "writing to #{filepath}"

    File.open(filepath, 'wb') do |file|
      object.read do |chunk|
         file.write(chunk)
      end
    end
  end

  def leaf_nodes(type)
    tree = bucket.as_tree(prefix: prefix(type))
    tree.children.select(&:leaf?)
  end

  def key(type, name)
    [prefix(type), name].join('/')
  end

  def prefix(type)
    [title.to_url, subfolder(type)].compact.join('/')
  end

  def subfolder(type)
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
