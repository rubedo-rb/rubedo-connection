require 'adamantium'

module Rubedo
  class Connection

    class Options
      include Adamantium

      class << self
        def inherited(subclass)
          props = self.respond_to?(:properties) ? properties.dup : Set[]
          subclass.instance_variable_set(:@properties, props)
          subclass.class.send(:attr_reader, :properties)
        end

        def property(name)
          memoize name
          self.properties.add(name)
        end

        def register(name, klass)
          @registry ||= {}
          @registry[name] = klass
        end

        def [](adapter)
          @registry[adapter.to_sym]
        end
      end

      self.inherited(self)

      ##
      # Database adapter
      #
      # Returns: {String}
      #
      property def adapter
        config[:adapter]
      end

      ##
      # Database name
      #
      # Returns: {String}
      #
      property def database
        config[:database] || config[:dbname]
      end

      ##
      # Connection username
      #
      # Returns: {String}
      #
      property def username
        config[:username] || config[:user] || ''
      end

      ##
      # Connection password
      #
      # Returns: {String}
      #
      property def password
        config[:password] || config[:pass] || ''
      end

      ##
      # Master hostname to connect
      #
      # Returns: {String}
      #
      property def host
        if config[:servers].kind_of?(Hash) && config[:servers].has_key?(:master)
          config[:servers][:master]
        else
          config[:host] || config[:socket] || config[:master]
        end
      end

      ##
      # Connection port
      #
      # Returns: {Integer}
      #
      property def port
        config[:port].to_i if config[:port]
      end

      ##
      # Database owner
      #
      # Returns: {String}
      #
      property def owner
        config[:owner]
      end

      ##
      # Database charset
      #
      # Returns: {String}
      #
      property def charset
        config[:charset] || config[:encoding] || 'utf8'
      end

      ##
      # Database collation
      #
      # Returns: {String}
      #
      property def collation
        config[:collation]
      end

      ##
      # List of slave servers
      #
      # Returns: {Set}
      #
      property def slaves
        list = if config[:servers].kind_of?(Hash) && config[:servers].has_key?(:slaves)
          config[:servers][:slaves]
        else
          config[:slaves]
        end

        Set.new(Array(list))
      end

      ##
      # Connection pool size
      #
      # Returns: {Integer}
      #
      property def pool_size
        (config[:pool_size] || 5).to_i
      end

      ##
      # Connection timeout in seconds
      #
      # Returns: {Integer}
      #
      property def pool_timeout
        (config[:pool_timeout] || 5).to_i
      end

      ##
      # Connection properties hash
      #
      # Returns: {Hash}
      #
      memoize def to_hash
        self.class.properties.each_with_object({}) do |prop, hash|
          value = public_send(prop)
          hash[prop] = value if value
        end
      end

      ##
      # Connection URI
      #
      # Returns: {String}
      #
      memoize def to_uri
        fail(NotImplementedError)
      end

    private

      attr_reader :config

      def initialize(config)
        @config = config
      end

    end

  end
end
