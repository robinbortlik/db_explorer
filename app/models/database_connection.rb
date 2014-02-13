class DatabaseConnection < ActiveRecord::Base
  validates :database, :adapter, :presence => :true
  validate :existing_file, :if => :sqlite3
  validate :working_configuration

  # Retrun hash with connection configuration, for ActiveRecord
  def config
    {database: database, username: username, password: password, adapter: adapter, host: host, port: port, encoding: encoding}
  end

  def to_s
    title.present? ? title : database
  end

  private

  # Be sure the connection to DB is working before store configuration
  def working_configuration
    begin
      Schema.new(config) if errors[:database].empty?
    rescue Exception => e
      errors.add(:database, e.to_s)
      return false
    end
  end

  # Check if connection is sqlite3
  def sqlite3
    adapter == "sqlite3"
  end

  # If connection is sqlite3, be sure the file is existing
  def existing_file
    if sqlite3 && database && !File.exist?(database)
      self.errors.add(:database, :not_exist)
    end
  end

end