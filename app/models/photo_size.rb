class PhotoSize
  def initialize(name, width, height)
    @name = name
    @width = width
    @height = height
  end

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
end
