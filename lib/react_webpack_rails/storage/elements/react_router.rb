require_relative 'base_element'

module ReactWebpackRails
  class Storage
    class Elements
      class ReactRouter < BaseElement
        def render_javascript
          "RWR.renderRouter('#{name}', document.getElementById('#{dom_element}'));"
        end

        private

        def generate_dom_key
          "react-router-#{name.downcase}"
        end
      end
    end
  end
end
