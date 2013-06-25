require_relative '../spec_helper'

describe Schema do

  describe "connection informations" do
    before(:each) {sleep(1)}

    it "get table names" do
      connection = FactoryGirl.create(:database_connection)
      schema_info = Schema.new(connection.config)
      schema_info.get_tables.find{|t| t == "articles"}.should_not be_nil
    end

    it "get table columns" do
      connection = FactoryGirl.create(:database_connection)
      schema_info = Schema.new(connection.config)
      schema_info.get_table_attributes("articles").find{|t| t == "string_1"}.should_not be_nil
    end

  end

end
