class NilPhoto < Photo
  def self.instance
    @instance ||= self.new
  end

  def url
    nil
  end

  def path
    nil
  end

  def version_url(version)
    nil
  end

  def filename
    nil
  end

  def alt
    nil
  end
end
