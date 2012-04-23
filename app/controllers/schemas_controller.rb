class SchemasController < ApplicationController
    
  def show
    collection
  end
 
  def search
    collection
    render :show
  end
  
  private
  
  def collection
    @database_connection = DatabaseConnection.find(params[:id])      
    @schema = Schema.new(@database_connection.config)
    if @name = params[:name]
       params[:q] = get_search_params_from_session(@database_connection.id, @name)
       @columns_names = @schema.get_table_attributes(@name)
       @model = @schema.get_schemas[@name]
       @search = @model.search(params[:q], :engine => @model)
       @collection =  @search.result.page(params[:page])
    end
  end
  
  def get_search_params_from_session(connection_id, name)
    key = "search_#{connection_id}_#{name}"
    session[key] = params[:q] if params[:q]   
    session[key] = nil if params[:clear_search]
    session[key]
  end
  
end