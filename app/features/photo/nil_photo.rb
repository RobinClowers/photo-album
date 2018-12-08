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

  def insecure_url
    ''
  end

  def secure_url
    ''
  end

  def thumb_url
    ''
  end
end
