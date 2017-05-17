module ReactWebpackRails
  module Install
    class ExampleGenerator < Rails::Generators::Base
      desc 'Add example component, its controller and router'
      source_root File.expand_path('../../templates', __FILE__)

      class_option :server_side,
                   type: :boolean,
                   default: true,
                   desc: 'Set server_side: true in example'

      def es6_example
        copy_file 'javascript/packs/hello-world.test.jsx', 'app/javascript/packs/tests/hello-world.test.jsx'
        copy_file 'javascript/packs/hello-world.jsx', 'app/javascript/packs/components/hello-world.jsx'
        append_to_file 'app/javascript/packs/application.js' do <<-'JS'.strip_heredoc

          import RWR from 'react-webpack-rails';
          RWR.run();

          import HelloWorld from './components/hello-world';
          RWR.registerComponent('HelloWorld', HelloWorld);
          JS
        end
      end

      def controller_and_view
        copy_file 'examples/react_examples_controller.rb', 'app/controllers/react_examples_controller.rb'
        template = "examples/component_view.html.erb"
        copy_file template, 'app/views/react_examples/component.html.erb'
      end

      def example_route
        route "get 'react_examples/component', to: 'react_examples#component', as: :component"
      end

      def javascript_tag
        inject_into_file 'app/views/layouts/application.html.erb', before: '</head>' do <<-'HTML'.strip_heredoc
          <%= javascript_pack_tag 'application' %>
          HTML
        end
      end
    end
  end
end
