class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: {maximum: Settings.maximum_user}
  validates :email, presence: true, length: {maximum: Settings.maximum_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.minimum_password}, allow_nil: true
  has_secure_password
  before_save :downcase_email

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost
    if cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def downcase_email
    email.downcase!
  end
end
