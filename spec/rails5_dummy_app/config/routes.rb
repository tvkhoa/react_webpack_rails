Rails.application.routes.draw do
  get 'react_examples/component', to: 'react_examples#component', as: :component
  get 'server_controller_component', to: 'pages#server_controller_component', as: :server_controller_component
  get 'server_view_component', to: 'pages#server_view_component', as: :server_view_component
  get 'client_component', to: 'pages#client_component', as: :client_component
  get 'client_counter_component', to: 'pages#client_counter_component', as: :client_counter_component
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
