module ReactWebpackRails
  class InstallGenerator < Rails::Generators::Base
    desc 'Prepare files necessary to use react-webpack-rails gem in a rails app.'
    source_root File.expand_path('../templates', __FILE__)

    class_option :example,
                 type: :boolean,
                 default: true,
                 desc: 'Run example generator.'
    class_option :hot_reload,
                 type: :boolean,
                 default: true,
                 desc: 'Run hot_reload generator'
    class_option :jest_setup,
                 type: :boolean,
                 default: true,
                 desc: 'Run jest_setup generator'
    class_option :redux,
                 type: :boolean,
                 default: false,
                 desc: 'Run redux generator'
    class_option :view_helpers,
                 type: :boolean,
                 default: true,
                 desc: 'Run view helpers generator'

    def generate_core
      generate 'react_webpack_rails:install:core --tmp-package'
    end

    def generate_example
      return unless options.example
      generate 'react_webpack_rails:install:example'
    end

    def generate_hot_reload
      return unless options.hot_reload
      generate 'react_webpack_rails:install:hot_reload --tmp-package'
    end

    def generate_jest_setup
      return unless options.jest_setup
      generate 'react_webpack_rails:install:jest_setup --tmp-package'
    end

    def generate_redux
      return unless options.redux
      generate 'react_webpack_rails:install:redux --tmp_package'
    end

    def generate_view_helpers
      return unless options.view_helpers
      generate 'react_webpack_rails:install:view_helpers --tmp_package'
    end

    def copy_package
      create_file 'package.json', File.read(Rails.root.join('tmp', 'package.json'))
    end

    def cleanup
      remove_file('tmp/package.json')
    end

    def install_gems
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end

    def install_packages
      run 'yarn install'
    end

    private

    def deprecation_warning
      message = [
        "\nDEPRECATION WARNING - since v0.3.0:",
        "current integration with react-router was extracted and moved to external plugin.",
        "Use https://github.com/netguru/rwr-react_router instead.\n\n",
      ]

      warn message.join("\n")
    end
  end
end
