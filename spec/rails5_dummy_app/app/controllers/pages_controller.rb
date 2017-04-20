class PagesController < ApplicationController
  def home
  end

  def server_controller_component
    render react_component: 'HelloWorld', props: { name: 'server controller' }
  end

  def server_view_component
    @name = 'server view'
  end

  def client_component
    @name = 'client'
  end
end
