module ReactWebpackRails
  module Install
    require 'generators/react_webpack_rails/merge_helpers'

    class HotReloadGenerator < Rails::Generators::Base
      include MergeHelpers
      desc 'Add hot reload setup'
      source_root File.expand_path('../../templates', __FILE__)

      class_option :tmp_package,
                   type: :boolean,
                   default: false,
                   desc: 'Force update tmp/package.json instead package.json'

      def package
        merge_options = options.tmp_package ? { package_file: 'tmp/package.json', force: true } : {}
        merge_into_package 'packages/hot-reload.json', merge_options
      end

      def webpack_output
        gsub_file 'config/webpack/shared.js', /^output\:(.*)\,$/ do
        <<-JS
          output: {
            filename: '[name].js',
            path: __dirname + '/app/assets/javascripts', // Save to Rails Asset Pipeline
            publicPath: 'http://localhost:8081/'
          },

        JS
        end
      end

      def modules_directories
        gsub_file 'webpack.config.js', /extensions\:(.*)/ do
        <<-JS
          extensions: ['.js', '.jsx', '.js.jsx'],
          modulesDirectories: ['node_modules', path.join(__dirname, 'app/react')]
        JS
        end
      end

      def module_hot
        append_to_file 'app/javascript/packs/applictions.js' do <<-'JS'.strip_heredoc

          import 'react-hot-loader/patch';

          if (module.hot) {
            module.hot.accept();
            RWR.reloadNodes();
          }
          JS
        end
      end
    end
  end
end
