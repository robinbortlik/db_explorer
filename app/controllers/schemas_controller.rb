class SchemasController < ApplicationController
    
  def show
    @database_connection = DatabaseConnection.find(params[:id])      
    @schema = Schema.new(@database_connection.config)
    if @name = params[:name]
      @columns_names = @schema.get_table_attributes(@name)
      @model = @schema.get_schemas[@name]
      @collection = @model.page(params[:page])
    end
  end
 
end