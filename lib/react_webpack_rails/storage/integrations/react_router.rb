require_relative 'base_integration'
require_relative '../elements/react_router'

module ReactWebpackRails
  class Storage
    class Integrations
      class ReactRouter < BaseIntegration
        def react_router(name, _, _)
          ReactWebpackRails::Storage::Elements::ReactRouter
            .new('react-router', name)
        end

        def integration_methods
          %w(react_router)
        end
      end
    end
  end
end
