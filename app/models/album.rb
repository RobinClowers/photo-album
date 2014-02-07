class Album < ActiveRecord::Base
  has_many :photos, inverse_of: :album
end
