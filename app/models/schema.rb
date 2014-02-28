require 'digest/md5'
require 'csv'

class Schema

  def initialize(config)
    @klass = define_class(config)
    @schemas = {}
    @connection = @klass.connection
    @connection.tables.each do |table_name|
      add_to_schema(config, table_name)
    end
  end


  # Return names of all table columns
  def get_table_attributes(table_name)
    get_schemas[table_name].columns.map(&:name)
  end

  # Return names of all tables for connection
  def get_tables
     get_schemas.keys
  end

  # Return all instantiated classes (models) for connection
  def get_schemas
    @schemas
  end

  def self.to_csv(column_names, collection)
    CSV.generate do |csv|
      csv << column_names
      collection.each do |obj|
        csv << obj.attributes.values_at(*column_names)
      end
    end
  end


  private

  # Dynamicly define models (classes which inherit from ActiveRecord::Base) and set dynamicly the name of table
  def define_class(config, table_name_string = nil)
    Class.new ActiveRecord::Base do
      def self.random_name
        (0...8).map { (65 + rand(26)).chr }.join
      end

      def self.name
        @name ||= random_name.classify
      end

      establish_connection config
      self.abstract_class = false
      cattr_accessor :model_name

      if table_name_string
        self.table_name = table_name_string
        self.model_name = ActiveModel::Name.new(self, nil, table_name_string.classify)
      end

    end
  end


  # Define class for some table and push it to schemas hash
  # { "Cars" => CarClass }
  def add_to_schema(config, table_name)
    klass = define_class(config, table_name)
    @schemas[table_name] = klass
  end
end