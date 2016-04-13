module ReactWebpackRails
  class Storage
    class Integrations
      class BaseIntegration
        def integration_method(method_name, name, props, options)
          return unless method_name.to_s.in?(integration_methods)
          public_send(method_name, name, props, options)
        end

        def integration_methods
          []
        end
      end
    end
  end
end
