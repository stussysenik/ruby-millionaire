class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true, on: :update

  def full_name
    [ first_name, last_name ].compact_blank.join(" ").presence || email_address
  end

  def admin?
    admin
  end
end
