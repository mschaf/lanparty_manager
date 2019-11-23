class User::SignIn < ActiveType::Object

  attribute :username
  attribute :password

  validates :username, presence: true
  validates :password, presence: true

  validate :user_exists, if: -> { username.present? && password.present? }

  def save
    if valid?
      user = User.find_by_name(username)&.authenticate(password)
      unless user
        errors.add :password, "wrong password"
      end
      user
    end
  end

  private

  def user_exists
    unless username.present? && User.find_by_name(username)
      errors.add :username, "user not found"
    end
  end

end
