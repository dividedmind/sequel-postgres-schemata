require "sequel/postgres/schemata/version"

module Sequel
  module Postgres
    module Schemata
      module DatabaseMethods

        # List all existing schematas (including the system ones).
        # Returns a symbol list.
        def schemata
          metadata_dataset.select(:nspname).from(:pg_namespace).map(:nspname).map(&:to_sym)
        end
        
        # Returns a symbol list containing the current search path.
        # Note that the search path can contain non-existent schematas.
        def search_path
          metadata_dataset.with_sql(SHOW_SEARCH_PATH).
            single_value.gsub('""', '"').split(", ").map(&:to_sym)
        end
        
        private
        
        SHOW_SEARCH_PATH = "SHOW search_path".freeze

      end
    end
    
    module DatabaseMethods
      include ::Sequel::Postgres::Schemata::DatabaseMethods
    end
  end
end
