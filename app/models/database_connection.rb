class DatabaseConnection < ActiveRecord::Base
  validates :database, :adapter, :presence => :true
  validate :working_configuration
  
  # Retrun hash with connection configuration, for ActiveRecord
  def config
    {database: database, username: username, password: password, adapter: adapter, host: host, port: port, encoding: encoding}
  end
  
  private
  
  # Be sure the connection to DB is working before store configuration
  def working_configuration
    begin
      Schema.new(config)
    rescue Exception => e
      errors.add(:database, e.to_s)
      return false
    end  
  end
    
end