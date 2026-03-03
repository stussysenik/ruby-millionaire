class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, {
    pending: 0,
    confirmed: 1,
    processing: 2,
    shipped: 3,
    delivered: 4,
    cancelled: 5
  }

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal_cents, :total_cents, presence: true

  before_validation :generate_order_number, on: :create

  scope :recent, -> { order(created_at: :desc) }

  def subtotal
    subtotal_cents / 100.0
  end

  def shipping
    shipping_cents / 100.0
  end

  def tax
    tax_cents / 100.0
  end

  def total
    total_cents / 100.0
  end

  def status_steps
    %w[pending confirmed processing shipped delivered]
  end

  def status_index
    status_steps.index(status) || 0
  end

  private

  def generate_order_number
    self.order_number ||= "AP-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
