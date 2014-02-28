class AbstractObjectsController < ApplicationController
  inherit_resources
  defaults :instance_name => 'abstract_object'

  before_filter :setup_class

  def create
    create!{schema_path(@database_connection, name: @name)}
  end

  def update
    update!{schema_path(@database_connection, name: @name)}
  end

  def destroy
    destroy!{schema_path(@database_connection, name: @name)}
  end

  private

  def setup_class
    @database_connection = DatabaseConnection.find(params[:connection_id])
    @schema = Schema.new(@database_connection.config)
    @name = params[:name]
    @model_name = @name.humanize
    self.class.resource_class = @schema.get_schemas[@name]
  end
end