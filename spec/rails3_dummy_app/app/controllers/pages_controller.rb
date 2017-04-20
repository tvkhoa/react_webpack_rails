class PagesController < ApplicationController
  def client_side_hello_world
    @name = 'username'
  end

  def react_component_renderer_test
    render react_component: 'HelloWorld', props: { name: 'render component test' }
  end
end
