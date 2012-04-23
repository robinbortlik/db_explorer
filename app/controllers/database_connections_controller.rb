class DatabaseConnectionsController < ApplicationController
  inherit_resources
  
  def create
    create!{collection_path}
  end  
  
  def update
    update!{collection_path}
  end  
  
  
  private
    
  def collection
    @database_connections = DatabaseConnection.order("database ASC").page(params[:page])
  end
end