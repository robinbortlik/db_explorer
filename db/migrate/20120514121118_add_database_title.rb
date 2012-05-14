class AddDatabaseTitle < ActiveRecord::Migration
  def change
    add_column :database_connections, :title, :string
  end
end
