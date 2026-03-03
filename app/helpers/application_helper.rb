module ApplicationHelper
  def format_price(cents)
    number_to_currency(cents / 100.0)
  end

  def stock_badge(product)
    if product.stock_quantity <= 0
      content_tag(:span, "Out of Stock", class: "badge-out-of-stock")
    elsif product.low_stock?
      content_tag(:span, "Low Stock (#{product.stock_quantity})", class: "badge-low-stock")
    else
      content_tag(:span, "In Stock", class: "badge-in-stock")
    end
  end

  def status_badge(status)
    colors = {
      "pending" => "bg-steel-400/10 text-steel-300 border-steel-400/30",
      "confirmed" => "bg-accent/10 text-accent border-accent/30",
      "processing" => "bg-caution/10 text-caution border-caution/30",
      "shipped" => "bg-accent/10 text-accent border-accent/30",
      "delivered" => "bg-success/10 text-success border-success/30",
      "cancelled" => "bg-danger/10 text-danger border-danger/30"
    }
    content_tag(:span, status.titleize, class: "badge #{colors[status] || colors['pending']}")
  end

  def product_image_url(product, variant: :thumb)
    if product.images.attached?
      case variant
      when :thumb
        url_for(product.images.first.variant(resize_to_fill: [ 400, 400 ]))
      when :medium
        url_for(product.images.first.variant(resize_to_fill: [ 600, 600 ]))
      when :large
        url_for(product.images.first)
      end
    end
  end

  def cart_count
    current_cart.total_items
  end
end
