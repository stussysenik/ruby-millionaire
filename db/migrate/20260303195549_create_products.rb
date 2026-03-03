class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sku, null: false
      t.text :description
      t.integer :price_cents, null: false
      t.integer :compare_at_price_cents
      t.integer :stock_quantity, default: 0, null: false
      t.references :category, null: false, foreign_key: true
      t.string :part_number
      t.string :mil_spec
      t.string :material
      t.string :certification
      t.decimal :weight_kg, precision: 8, scale: 3
      t.integer :temperature_min
      t.integer :temperature_max
      t.json :specifications, default: {}
      t.boolean :active, default: true, null: false
      t.boolean :featured, default: false, null: false

      t.timestamps
    end
    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
    add_index :products, :part_number
    add_index :products, :active
    add_index :products, :featured
  end
end
