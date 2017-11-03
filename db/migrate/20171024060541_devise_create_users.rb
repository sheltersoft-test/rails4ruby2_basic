class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.integer :brand_id,  null: false
      t.integer :creator_id
      t.integer :updater_id

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      #User Details
      t.string :first_name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.date :birthdate
      t.string :ssn, limit: 50
      t.text :address, limit: 500
      t.integer :post_number
      t.string :city, limit: 50
      t.string :phone_number, limit: 50
      t.string :personal_email, limit: 50
      t.string :gender, limit: 1
      t.string :sv_number, limit: 50
      t.integer :relationship_type, default: 0, null: false
      t.date :contract_start_date
      t.date :contract_end_date
      t.integer :contract_type, default: 0, null: false
      t.boolean :contract_probation, default: false, null: false
      t.integer :job_role
      t.string :other_job_role
      t.integer :specialty, :default => 0, null: false
      t.text :languages, limit: 65535
      t.string :job_title, limit: 50
      t.text :other_business_degrees, limit: 65535
      t.boolean :perform_dentist_work, default: true, null: false
      t.integer  :language
      t.text :introduction, limit: 65535
      t.text :working_areas, limit: 65535
      t.string :linkedin_url, limit: 255
      t.string :facebook_url, limit: 255
      t.string :twitter_url, limit: 255
      
      t.boolean :registered, null: false, default: false
      t.boolean :intermediate, null: false, default: false
      t.boolean :is_active, null: false,  default: true
      t.boolean :is_deleted, null: false, default: false  

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
