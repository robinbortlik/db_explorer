require 'spec_helper'

describe "DatabaseConnections" do

  before(:each) do
    @connection = FactoryGirl.create(:database_connection)
    @schema = Schema.new(@connection.config)
    @model = @schema.get_schemas["articles"]
    @model.delete_all
    @article = @model.create(:string_1 => "some short text")
  end

  describe "GET /database_connections/:connection_id/schemas/:name" do
    it "display list with abstracts objects and links for edit, destroy and new" do
      visit schema_path(@connection, name: "articles")
      page.should have_content("some short text")
      page.should have_content("New")
      page.should have_content("Edit")
      page.should have_content("Destroy")
    end

  end


  describe "GET /database_connections/:connection_id/schemas/:name/new" do
     it "allow me to create abstract object" do
       visit new_abstract_path(connection_id: @connection.id, name: "articles")
       fill_in('String 1', :with => 'some new string')
       click_on "Create Article"
       page.should have_content("some new string")
       current_path.should == schema_path(@connection, name: "articles")
     end
   end

   describe "GET /database_connections/:connection_id/schemas/:name/:id/edit" do
      it "allow me to edit abstract object" do
        visit edit_abstract_path(@article, connection_id: @connection.id, name: "articles")
        fill_in('String 1', :with => 'some edited string')
        click_on "Update Article"
        page.should have_content("some edited string")
        current_path.should == schema_path(@connection, name: "articles")
      end
    end


    describe "GET /database_connections/:connection_id/schemas/:name/:id" do
      it "allow me to destroy abstract object" do
        visit schema_path(@connection, name: "articles")
        click_on "Destroy"
        page.should have_no_content("some short text")
        current_path.should == schema_path(@connection, name: "articles")
      end
    end


end
