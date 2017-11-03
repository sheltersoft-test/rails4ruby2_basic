class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
    	t.integer :brand_id, null: false
    	t.string :setting_label, null: false
    	t.string :setting_value
      t.integer :creator_id
      t.integer :updater_id
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false

      t.timestamps null: false
    end
  end
end
