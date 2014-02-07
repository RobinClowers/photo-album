class Album < ActiveRecord::Base
  has_many :photos, inverse_of: :album
  belongs_to :cover_photo, class_name: :photo
end
