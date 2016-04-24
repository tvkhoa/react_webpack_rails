require 'rails_helper'

feature 'client_side_hello_world page', js: true do
  subject { page }

  before { visit root_path }

  it 'renders react component with attribute from Rails controller' do
    expect(page).to have_content('Rails 5 dummy app')
    visit(react_component_renderer_test_path)
    expect(page).to have_content('Hello World render component test')
  end
end
