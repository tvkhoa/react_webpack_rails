require_relative '../../services/camelize_keys'

module ReactWebpackRails
  class Storage
    class Elements
      class BaseElement
        attr_accessor :integration, :name, :props, :options, :dom_element

        def initialize(integration, name, props = {}, options = {})
          @integration = integration
          @name = name
          @props = props
          @options = options
          @dom_element = generate_dom_key
        end

        def add_prop(key, value)
          @props[key] = value
        end

        def remove_prop(key)
          @props.delete!(key)
        end

        def render_javascript
          fail 'This method has to be implemented in child class'
        end

        def translated_props
          Services::CamelizeKeys.call(props)
        end

        private

        def generate_dom_key
          "react-#{name.downcase}-#{SecureRandom.hex(4)}"
        end
      end
    end
  end
end
