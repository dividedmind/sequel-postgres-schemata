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
            single_value.scan(SCHEMA_SCAN_RE).flatten.
            map{|s|s.sub(SCHEMA_SUB_RE, '\1').gsub('""', '"').to_sym}
        end
        
        # Sets the search path. Starting with Postgres 9.2 it can contain
        # non-existent schematas.
        # Accepted formats include a single symbol, a single string (passed
        # to the server verbatim) and lists of symbols or strings.
        def search_path= search_path
          case search_path
          when String
            search_path = search_path.split(",").map{|s| s.strip}
          when Array
            # nil
          else
            raise Error, "unrecognized value for search_path: #{search_path.inspect}"
          end
          self << "SET search_path = #{search_path.map{|s| "\"#{s.to_s.gsub('"', '""')}\""}.join(',')}"
        end
        
        private
        
        SHOW_SEARCH_PATH = "SHOW search_path".freeze
        SCHEMA_SCAN_RE = /(?<=\A|, )(".*?"|.*?)(?=, |\z)/.freeze
        SCHEMA_SUB_RE = /\A"(.*)"\z/.freeze
      end
    end
    
    module DatabaseMethods
      include ::Sequel::Postgres::Schemata::DatabaseMethods
    end
  end
end
