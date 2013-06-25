require 'spec_helper'

describe "DatabaseConnections" do
  describe "GET /database_connections" do
    it "display link for new connection if there is no one" do
      visit database_connections_path
      page.should have_content("No connection to database created yet. Create new !")
    end

    it "display link for new connection if there is no one" do
      visit root_path
      click_link("new")
      page.should have_content("New Database connection")
      current_path.should == new_database_connection_path
    end

    it "display list of database connections if there are some" do
      connection = FactoryGirl.create(:database_connection)
      visit root_path
      page.should have_content connection.database
    end

  end

  describe "POST /database_connections" do
    it "validate adapter and database name" do
      visit new_database_connection_path
      click_on "Create Database connection"
      page.should have_content("can't be blank")
    end

    it "allow user to create connection" do
      visit new_database_connection_path
      select('sqlite3', :from => 'Adapter')
      fill_in('Database', :with => 'spec/db/test.sqlite3')
      click_on "Create Database connection"
      page.should have_content("spec/db/test.sqlite3")
      current_path.should == database_connections_path
    end

  end

  describe "GET /database_connections/:id/edit" do
    before(:each) do
      @connection = FactoryGirl.create(:database_connection)
    end

    it "display link for edit in list" do
      visit database_connections_path
      page.should have_content(@connection.database)
      click_on "Edit"
      current_path.should == edit_database_connection_path(@connection)
      page.should have_content("Edit Database connection")
    end

    it "allow user to edit connection" do
      visit edit_database_connection_path(@connection)
      select('sqlite3', :from => 'Adapter')
      fill_in('Database', :with => 'spec/db/test2.sqlite3')
      click_on "Update Database connection"
      page.should have_content("spec/db/test2.sqlite3")
      current_path.should == database_connections_path
    end

  end

  describe "DELETE /database_connections/:id" do
    before(:each) do
      @connection = FactoryGirl.create(:database_connection)
    end

    it "display link for destroy in list" do
      visit database_connections_path
      page.should have_content(@connection.database)
      #evaluate_script 'window.confirm = function() { return true; }'
      click_on "Destroy"
      current_path.should == database_connections_path
      page.should have_content("No connection to database created yet. Create new !")
    end

  end
end
