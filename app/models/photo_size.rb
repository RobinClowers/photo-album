PhotoSize = Struct.new(:name, :width, :height) do
  # 428 x 321
  def self.mobile
    new('mobile', :natural, 321)
  end

  # 768 x 576
  def self.tablet
    new('tablet',:natural, 576)
  end

  # 1024 x 768
  def self.laptop
    new('laptop', :natural, 768)
  end

  # 2048 x 1535
  def self.desktop
    new('desktop', :natural, 1536)
  end

  def self.original
    new('original', :natural, :natural)
  end

  def self.all
    [mobile, tablet, laptop, desktop]
  end

  def self.from_name(name)
    self.send(name)
  end

  def self.from_names(names)
    return self.all if names == 'all'
    names.map { |name| self.from_name(name) }
  end

  def photo_path(base_path, filename)
    File.join(base_path, name, filename)
  end

  def full_path(base_path)
    File.join(base_path, name)
  end

  def geometry_string
    geometry_height = height unless height == :natural
    geometry_width = width unless width == :natural
    "#{geometry_width}x#{geometry_height}"
  end
end
