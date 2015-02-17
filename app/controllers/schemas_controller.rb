class SchemasController < ApplicationController

  def search
    collection
    render :show
  end

  def show
    collection
    respond_to do |format|
      format.html { }
      format.csv { render text: Schema.to_csv(@columns_names, @model.all) }
    end
  end

  private

  def collection
    @database_connection = DatabaseConnection.find(params[:id])
    @schema = Schema.new(@database_connection.config)
    if @name = params[:name]
      params[:q] = get_search_params_from_session(@database_connection.id, @name)
      @columns_names = @schema.get_table_attributes(@name)
      @model = @schema.get_schemas[@name]
      @search = @model.ransack(params[:q], :engine => @model)
      @collection =  @search.result.page(params[:page]).per(get_per_page(@database_connection.id, @name))
    end
  end

  def get_search_params_from_session(connection_id, name)
    key = "search_#{connection_id}_#{name}"
    session[key] = params[:q] if params[:q]
    session[key] = nil if params[:clear_search]
    session[key]
  end

  def get_per_page(connection_id, name)
    key = "search_#{connection_id}_#{name}_per_page"
    session[key] = params[:per_page] if params[:per_page]
    session[key]
  end

end
