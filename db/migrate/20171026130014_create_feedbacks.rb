class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :brand_id, null: false
      t.integer :sender_id, null: false
      t.integer :subject, :default => 0, null: false
      t.text :message, limit: 65535
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false

      t.timestamps null: false
    end
  end
end
