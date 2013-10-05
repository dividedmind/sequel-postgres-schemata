require 'spec_helper'

describe Sequel::Postgres::Schemata do

  describe "#schemata" do
    it "lists all existing schematas"
  end
  
  describe "#search_path" do
    it "returns the search path"
  end
  
  describe "#search_path=" do
    it "sets the search path"
  end
  
  describe "#current_schemata" do
    it "returns the current schemata"
  end
  
  describe "#rename_schema" do
    it "renames a schema"
  end

end
