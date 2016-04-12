module ReactWebpackRails
  module Install
    require 'generators/react_webpack_rails/merge_helpers'

    class ReduxGenerator < Rails::Generators::Base
      include MergeHelpers
      desc 'Add redux setup'
      source_root File.expand_path('../../templates', __FILE__)

      class_option :tmp_package,
                   type: :boolean,
                   default: false,
                   desc: 'Force update tmp/package.json instead package.json'

      def package
        merge_options = options.tmp_package ? { package_file: 'tmp/package.json', force: true } : {}
        merge_into_package 'packages/redux.json', merge_options
      end

      def add_integration_managers
        inject_into_file 'app/react/index.js', after: "import RWR from 'react-webpack-rails';\n" do
          "import RWRRedux from 'rwr-redux';\n"
        end

        inject_into_file 'app/react/index.js', after: "RWR.run();\n" do
          <<-'JS'.strip_heredoc

            integrationsManager.register('redux-store', RWRRedux.storeIntegrationWrapper);
            integrationsManager.register('redux-container', RWRRedux.containerIntegrationWrapper);
          JS
        end
      end
    end
  end
end
