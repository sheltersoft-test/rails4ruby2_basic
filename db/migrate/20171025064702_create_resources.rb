class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
    	t.integer :resource_holder_id, null: false
      t.string :resource_holder_type, null: false
      t.integer :resource_spec_id, null: false
      t.integer :resource_type_id, null: false
      t.string :media_attachment_name, null: true      
      t.boolean :limited, default: false, null: false
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false

      t.timestamps null: false
    end
  end
end
