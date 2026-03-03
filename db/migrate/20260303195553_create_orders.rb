class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_number, null: false
      t.integer :status, default: 0, null: false
      t.integer :subtotal_cents, null: false
      t.integer :shipping_cents, default: 0, null: false
      t.integer :tax_cents, default: 0, null: false
      t.integer :total_cents, null: false
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.string :currency, default: "usd"

      # Denormalized shipping address
      t.string :shipping_name
      t.string :shipping_line1
      t.string :shipping_line2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_postal_code
      t.string :shipping_country

      # Denormalized billing address
      t.string :billing_name
      t.string :billing_line1
      t.string :billing_line2
      t.string :billing_city
      t.string :billing_state
      t.string :billing_postal_code
      t.string :billing_country

      t.timestamps
    end
    add_index :orders, :order_number, unique: true
    add_index :orders, :stripe_checkout_session_id
    add_index :orders, :status
  end
end
