class User < ApplicationRecord

  validates :name, presence: true, uniqueness: true,  length: {in: 3..20}
  validates :display_name, presence: true, length: {in: 3..20}
  validates :name, format: { with: /\A[a-zA-Z0-9_\-üöäÜÖÄß]+\z/,  message: "can only contain letters, numbers, dashes and underscores" }

  before_validation :set_display_name_from_name, unless: -> { display_name.present? }
  validate :locked, on: :create

  has_many :songs, dependent: :nullify

  has_secure_password


  def authenticated_by_token?(token)
    return false if remember_token.nil?
    BCrypt::Password.new(remember_token).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def set_display_name_from_name
    self.display_name = name
  end

  def self.current

  end

end
