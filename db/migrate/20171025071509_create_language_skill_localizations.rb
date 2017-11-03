class CreateLanguageSkillLocalizations < ActiveRecord::Migration
  def change
    create_table :language_skill_l10ns do |t|
      t.integer :language_skill_id, null: false
      t.string :name, limit: 100, null: false
      t.integer :language_code, default: 0, null: false
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false

      t.timestamps null: false
    end

    add_index :language_skill_l10ns, [:language_skill_id, :language_code], unique: true, name: "idx_l_skill_l10ns_l_skill_id_language_code"
  end
end
