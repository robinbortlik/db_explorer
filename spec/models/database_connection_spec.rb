require_relative '../spec_helper'

describe DatabaseConnection do

  describe "attributes" do
    [:adapter, :database, :username, :password, :host, :encoding, :port].each do |attr|
      it "have #{attr} attribute" do
        connection = DatabaseConnection.new
        connection.should respond_to(attr)
      end
   end
  end

  describe "validations" do
    [:adapter, :database].each do |attr|
      it "#{attr} is required" do
        connection = DatabaseConnection.new
        connection.should_not be_valid
        connection.errors[attr].should_not be_blank
      end
    end

    it "should try if connection is available" do
      connection = DatabaseConnection.new
      connection.adapter = "postgresql"
      connection.database = "some_bad_db_name"
      connection.should_not be_valid
      connection.errors[:database].should_not be_blank

      connection.adapter = "sqlite3"
      connection.database = "spec/db/test.sqlite3"
      connection.should be_valid
      connection.errors[:database].should be_blank
    end

    it "validate if file of slite3 database really exist" do
      connection = DatabaseConnection.new
      connection.adapter = "sqlite3"
      connection.database = "spec/db/wrongdbname.sqlite3"
      connection.should_not be_valid
      connection.errors[:database].first.should == "File with database does not exist. Be sure you specify right path"
      connection.database = "spec/db/test.sqlite3"
      connection.should be_valid
    end
  end



  describe "configuration" do
    it "generate configuration" do
      connection = FactoryGirl.create(:database_connection)
      connection.config.keys.should include :adapter, :database, :username, :password, :host, :encoding, :port
    end
  end

  describe "title" do
    it "respond to title" do
      connection = FactoryGirl.create(:database_connection)
      connection.should respond_to(:title)
    end

    it "to_s return title " do
      connection = FactoryGirl.create(:database_connection)
      connection.title = "Database title"
      connection.to_s.should == connection.title
    end

     it "to_s return database name if title nil" do
        connection = FactoryGirl.create(:database_connection)
        connection.title = nil
        connection.to_s.should == connection.database
     end
  end

end
