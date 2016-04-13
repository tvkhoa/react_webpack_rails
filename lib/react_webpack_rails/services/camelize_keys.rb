module ReactWebpackRails
  module Services
    class CamelizeKeys
      def call(props)
        return props unless props.is_a?(Hash)
        props.inject({}) do |h, (k, v)|
          h[k.to_s.camelize(:lower)] = prop_value(v)
          h
        end
      end

      def self.call(props)
        new.call(props)
      end

      private

      def prop_value(prop_value)
        case prop_value.class.name
        when 'Array' then prop_value.map { |prop| call(prop) }
        when 'Hash' then call(prop_value)
        else prop_value
        end
      end
    end
  end
end
