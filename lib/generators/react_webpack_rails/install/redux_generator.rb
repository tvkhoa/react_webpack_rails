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
    end
  end
end
