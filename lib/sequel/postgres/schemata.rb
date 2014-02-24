require "sequel/postgres/schemata/version"

Sequel.extension :pg_array

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
            single_value.scan(SCHEMA_SCAN_RE).flatten.
            map{|s|s.strip.sub(SCHEMA_SUB_RE, '\1').gsub('""', '"').to_sym}
        end
        
        # Sets the search path. Starting with Postgres 9.2 it can contain
        # non-existent schematas.
        # Accepted formats include a single symbol, a single string (passed
        # to the server verbatim) and lists of symbols or strings.
        def search_path= search_path
          case search_path
          when String
            search_path = search_path.split(",").map{|s| s.strip}
          when Symbol
            search_path = [search_path]
          when Array
            # nil
          else
            raise Error, "unrecognized value for search_path: #{search_path.inspect}"
          end
          self << "SET search_path = #{search_path.map{|s| "\"#{s.to_s.gsub('"', '""')}\""}.join(',')}"
        end
        
        # Returns the current schemata, as returned by current_schemas(false).
        def current_schemata
          extension :pg_array
          metadata_dataset.select(Sequel::function(:current_schemas, false).
            cast('varchar[]')).single_value.map(&:to_sym)
        end
        
        # Renames a schema
        def rename_schema from, to
          self << RENAME_SCHEMA_SQL % [from.to_s.gsub('"', '""'), to.to_s.gsub('"', '""')]
        end
        
        private
        
        SHOW_SEARCH_PATH = "SHOW search_path".freeze
        SCHEMA_SCAN_RE = /(?<=\A|,)(".*?"|.*?)(?=,|\z)/.freeze
        SCHEMA_SUB_RE = /\A"(.*)"\z/.freeze
        RENAME_SCHEMA_SQL = 'ALTER SCHEMA "%s" RENAME TO "%s"'.freeze
      end
    end
    
    module DatabaseMethods
      include ::Sequel::Postgres::Schemata::DatabaseMethods
    end
    
    Database.send :include, ::Sequel::Postgres::Schemata::DatabaseMethods if defined? Database
  end
end
