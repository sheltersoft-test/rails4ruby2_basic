class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name, limit: 100, null: false
      t.string :slug, limit: 100, null: true
      t.string :custom_domain, limit: 100, null: true
      t.string :custom_domain_type, limit: 100, null: true
      t.string :redirect_domain, limit: 100, null: true
      t.string :prefix, limit: 10, null: false
      t.text :description, limit: 2000
      t.string :phone_number, limit: 50
      t.string :email, limit: 50
      t.string :site_description
      t.string :site_keywords
      t.string :site_title
      t.string :country_code, :string
      t.string :currency_code, :string
      t.string :currency_sign, :string
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false

      t.timestamps null: false
    end
    add_index :brands, :name, unique: true
    add_index :brands, :prefix, unique: true
  end
end
