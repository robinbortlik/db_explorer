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
    order = ActiveRecord::Base.connection.adapter_name == 'Mysql2' ? "`database_connections`.`database` ASC" : "database_connections.database ASC"
    @database_connections = DatabaseConnection.order(order).page(params[:page])
  end
end
