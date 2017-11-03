class CreateUserSkills < ActiveRecord::Migration
  def change
    create_table :user_skills do |t|
      t.integer :user_id, null: false
      t.string :skill_type, null: false
      t.integer :skill_id, null: false
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false
      
      t.timestamps null: false
    end

    add_index :user_skills, [:user_id, :skill_type, :skill_id], unique: true
  end
end
