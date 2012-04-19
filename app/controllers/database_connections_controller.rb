class DatabaseConnectionsController < ApplicationController
  inherit_resources
  
  def create
    create!{collection_path}
  end  
  
  def update
    update!{collection_path}
  end  
  
end