class Photo < ActiveRecord::Base
  belongs_to :album, inverse_of: :photos
end
