class Address < ApplicationRecord
  belongs_to :user

  validates :name, :line1, :city, :state, :postal_code, :country, presence: true

  def full_address
    [ line1, line2, "#{city}, #{state} #{postal_code}", country ].compact_blank.join("\n")
  end

  def one_line
    [ line1, city, state, postal_code ].compact_blank.join(", ")
  end
end
