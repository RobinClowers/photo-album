class NilPhoto < Photo
  def self.instance
    @instance ||= self.new
  end

  def url
    ''
  end

  def path
    ''
  end

  def version_url(version)
    ''
  end

  def filename
    ''
  end

  def alt
    'Missing photo'
  end
end
