class AddPubsubhubbubToUser < ActiveRecord::Migration
  def change
    
    add_column :users, :pubsubhubbub_host, :string
    add_column :users, :pubsubhubbub_username, :string
    add_column :users, :pubsubhubbub_password, :string

  end
end
