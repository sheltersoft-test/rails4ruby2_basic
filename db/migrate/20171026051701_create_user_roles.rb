class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id, null: false
      t.integer :role, default: 0, null: false

      t.timestamps null: false
    end
    add_index :user_roles, [:user_id, :role], unique: true, name: "idx_user_id_role"
  end
end
