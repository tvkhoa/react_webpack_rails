Rails.application.routes.draw do
  get 'react_component_renderer_test', to: 'pages#react_component_renderer_test', as: :react_component_renderer_test
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
