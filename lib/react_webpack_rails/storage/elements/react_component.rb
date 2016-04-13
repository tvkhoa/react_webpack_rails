require_relative 'base_element'

module ReactWebpackRails
  class Storage
    class Elements
      class ReactComponent < BaseElement
        def render_javascript
          "RWR.renderComponent('#{name}', #{translated_props.to_json}," \
                               " document.getElementById('#{dom_element}'));"
        end
      end
    end
  end
end
