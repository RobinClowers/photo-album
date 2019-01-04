class Photo::FilenameScrubber
  DOT_REGEX = /\.(?=.*\.)/

  def self.scrub(filename)
    filename.gsub(DOT_REGEX, "-")
  end
end
