require 'spec_helper'

describe Sequel::Postgres::Schemata do
  
  let(:db) { Sequel::connect adapter: 'postgres', search_path: %w(foo public) } 
  let(:plain_db) { Sequel::connect adapter: 'postgres' }

  describe "#schemata" do
    it "lists all existing schematas" do
      schemata = db.schemata
      schemata.should include(:public)
      schemata.should_not include(:foo)
    end
  end
  
  describe "#search_path" do
    it "returns the search path" do
      db.search_path.should == %i(foo public)
    end

    it "correctly handles the default list" do
      expect(plain_db.search_path).to eq(%i($user public))
    end

    describe "with a block" do
      it "changes the search path temporarily" do
        db.search_path :bar do
          db.search_path.should == %i(bar)
        end
        db.search_path.should == %i(foo public)
      end

      it "accepts symbols as arglist" do
        db.search_path :bar, :baz do
          db.search_path.should == %i(bar baz)
        end
        db.search_path.should == %i(foo public)
      end

      it "allows prepending with prepend: true" do
        db.search_path :bar, prepend: true do
          db.search_path.should == %i(bar foo public)
        end
        db.search_path.should == %i(foo public)
      end
    end
  end
  
  describe "#search_path=" do
    it "accepts a single symbol" do
      db.search_path = :bar
      db.search_path.should == %i(bar)
    end
    
    it "accepts a single string" do
      db.search_path = 'bar'
      db.search_path.should == %i(bar)
    end
    
    it "accepts a formatted string" do
      db.search_path = 'bar, baz'
      db.search_path.should == %i(bar baz)
    end
    
    it "accepts a symbol list" do
      db.search_path = %i(bar baz)
      db.search_path.should == %i(bar baz)
    end
    
    it "accepts a string list" do
      db.search_path = %w(bar baz)
      db.search_path.should == %i(bar baz)
    end

    it "quotes the string list correctly" do
      db.search_path = ["bar\" ',", "baz"]
      db.search_path.should == [:"bar\" ',", :baz]
    end
  end
  
  describe "#current_schemata" do
    it "returns the current schemata" do
      db.current_schemata.should == %i(public)
    end
  end
  
  describe "#rename_schema" do
    it "renames a schema" do
      db.transaction rollback: :always do
        db.create_schema :test_schema
        db.schemata.should include(:test_schema)
        db.current_schemata.should == %i(public)
        db.rename_schema :test_schema, :foo
        db.current_schemata.should == %i(foo public)
      end
    end
  end

end
