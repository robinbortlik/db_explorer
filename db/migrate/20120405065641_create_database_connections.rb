class CreateDatabaseConnections < ActiveRecord::Migration
  def change
    create_table :database_connections do |t|
      t.string :adapter, :null => false
      t.string :database, :null => false
      t.string :password
      t.string :username
      t.string :host
      t.string :encoding
      t.integer :port
    end  
  end
end
