class Photo < ActiveRecord::Base
  has_one :album, inverse_of: :photos
end
