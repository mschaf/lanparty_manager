class Game < ApplicationRecord

  mount_uploader :cover_image, GameCoverImageUploader

  validates :name, presence: true

end
