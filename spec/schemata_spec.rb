require 'spec_helper'

describe Sequel::Postgres::Schemata do
  
  let(:db) {
    Sequel::connect(
      adapter: 'postgres',
      database: 'postgres',
      search_path: %w(foo public),
      host: 'db',
      user: 'postgres',
      password: 'example'
    )
  } 
  let(:plain_db) {
    Sequel::connect(
      adapter: 'postgres',
      database: 'postgres',
      host: 'db',
      user: 'postgres',
      password: 'example'
    )
  }

  describe "#schemata" do
    it "lists all existing schematas" do
      schemata = db.schemata
      expect(schemata).to include(:public)
      expect(schemata).to_not include(:foo)
    end
  end
  
  describe "#search_path" do
    it "returns the search path" do
      expect(db.search_path).to eq(%i(foo public))
    end

    it "correctly handles the default list" do
      expect(plain_db.search_path).to eq(%i($user public))
    end

    describe "with a block" do
      it "changes the search path temporarily" do
        db.search_path :bar do
          expect(db.search_path).to eq(%i(bar))
        end
        expect(db.search_path).to eq(%i(foo public))
      end

      it "resets the search path when the given block raises an error" do
        class MyContrivedError < StandardError; end

        begin
          db.search_path :bar do
            expect(db.search_path).to eq(%i(bar))
            raise MyContrivedError.new
          end
        rescue MyContrivedError
          # Gobble.
        end
        expect(db.search_path).to eq(%i(foo public))
      end

      it "accepts symbols as arglist" do
        db.search_path :bar, :baz do
          expect(db.search_path).to eq(%i(bar baz))
        end
        expect(db.search_path).to eq(%i(foo public))
      end

      it "allows prepending with prepend: true" do
        db.search_path :bar, prepend: true do
          expect(db.search_path).to eq(%i(bar foo public))
        end
        expect(db.search_path).to eq(%i(foo public))
      end
    end
  end
  
  describe "#search_path=" do
    it "accepts a single symbol" do
      db.search_path = :bar
      expect(db.search_path).to eq(%i(bar))
    end
    
    it "accepts a single string" do
      db.search_path = 'bar'
      expect(db.search_path).to eq(%i(bar))
    end
    
    it "accepts a formatted string" do
      db.search_path = 'bar, baz'
      expect(db.search_path).to eq(%i(bar baz))
    end
    
    it "accepts a symbol list" do
      db.search_path = %i(bar baz)
      expect(db.search_path).to eq(%i(bar baz))
    end
    
    it "accepts a string list" do
      db.search_path = %w(bar baz)
      expect(db.search_path).to eq(%i(bar baz))
    end

    it "quotes the string list correctly" do
      db.search_path = ["bar\" ',", "baz"]
      expect(db.search_path).to eq([:"bar\" ',", :baz])
    end
  end
  
  describe "#current_schemata" do
    it "returns the current schemata" do
      expect(db.current_schemata).to eq(%i(public))
    end
  end
  
  describe "#rename_schema" do
    it "renames a schema" do
      db.transaction rollback: :always do
        db.create_schema :test_schema
        expect(db.schemata).to include(:test_schema)
        expect(db.current_schemata).to eq(%i(public))
        db.rename_schema :test_schema, :foo
        expect(db.current_schemata).to eq(%i(foo public))
      end
    end
  end

end
