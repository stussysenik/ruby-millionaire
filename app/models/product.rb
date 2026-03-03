class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify
  has_many_attached :images

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :sku, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :in_stock, -> { where("stock_quantity > 0") }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }

  before_validation :generate_slug, if: -> { slug.blank? }

  def self.ransackable_attributes(auth_object = nil)
    %w[name sku part_number mil_spec material certification price_cents category_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  def to_param
    slug
  end

  def price
    price_cents / 100.0
  end

  def compare_at_price
    compare_at_price_cents&./(100.0)
  end

  def on_sale?
    compare_at_price_cents.present? && compare_at_price_cents > price_cents
  end

  def in_stock?
    stock_quantity > 0
  end

  def low_stock?
    stock_quantity > 0 && stock_quantity <= 5
  end

  def temperature_range
    return nil unless temperature_min && temperature_max
    "#{temperature_min}°F to #{temperature_max}°F"
  end

  private

  def generate_slug
    self.slug = name&.parameterize
  end
end
