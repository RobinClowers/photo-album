class CoverPhotoValidator < ActiveModel::EachValidator
  def validate_each(album, attribute, value)
    return unless album.photos.include?(album[:attribute])
    album.errors[:attribute].add("cover photo isn't in this album")
  end
end
