class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo

  validates :body, presence: true
end
