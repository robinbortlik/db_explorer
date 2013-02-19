require 'spec_helper'

describe "Schemas" do
  describe "GET /database_connections/:id/schemas" do
    
    before(:each) do
      @connection = Factory(:database_connection) 
    end
    
    it "display  table names" do
      visit schemas_path(@connection)
      within "ul.tables_list" do
        page.should have_content("articles")
        page.should have_content("schema_migrations")
      end
      page.should have_content("Please select some table from list")
    end
    
    it "display table content" do
      visit schemas_path(@connection)
      click_link "articles"
      within "table.table" do 
        page.should have_content("id")
        page.should have_content("string_1")	
        page.should have_content("string_2")	
        page.should have_content("text_1")
        page.should have_content("date_1")	
        page.should have_content("integer_1")
        page.should have_content("country")
        page.should have_content("state")
      end
    end
  end
end
