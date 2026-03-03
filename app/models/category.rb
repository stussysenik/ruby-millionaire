class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :roots, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position, :name) }

  before_validation :generate_slug, if: -> { slug.blank? }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name&.parameterize
  end
end
