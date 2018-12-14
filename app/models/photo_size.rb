PhotoSize = Struct.new(:name, :width, :height) do
  # 640 x 480
  def self.mobile_sm
    new('mobile_sm', :natural, 480)
  end

  # 1280 x 960
  def self.mobile_lg
    new('mobile_lg',:natural, 960)
  end

  # 1536 x 1152
  def self.tablet
    new('tablet',:natural, 1152)
  end

  # 2048 x 1535
  def self.laptop
    new('laptop', :natural, 1535)
  end

  # 3072 x 2304
  def self.desktop
    new('desktop', :natural, 2304)
  end

  def self.original
    new('original', :natural, :natural)
  end

  def self.all
    [mobile_sm, mobile_lg, tablet, laptop, desktop, original]
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
