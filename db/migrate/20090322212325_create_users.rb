class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|

      t.column :login,                     :string, :limit => 40
      t.column :email,                     :string, :limit => 100
      t.column :first_name,                :string, :limit => 100
      t.column :last_name,                 :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime
    end
    
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
