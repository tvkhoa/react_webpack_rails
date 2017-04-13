Rails.application.routes.draw do
  get 'client_side_hello_world', to: 'pages#client_side_hello_world', as: :client_side_hello_world
  get 'react_component_renderer_test', to: 'pages#react_component_renderer_test', as: :react_component_renderer_test

  root 'example#react'
end
