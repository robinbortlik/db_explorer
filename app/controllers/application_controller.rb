class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_connections
  
  
  private
  
  def load_connections
    @database_connections = DatabaseConnection.all
  end
  
end
