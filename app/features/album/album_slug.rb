AlbumSlug = Struct.new("AlbumSlug", :slug) do
  def initialize(title_or_slug)
    super(title_or_slug.to_s.to_url)
  end

  def to_title
    slug.titleize.gsub('And', '&')
  end

  def to_s
    slug
  end
end
