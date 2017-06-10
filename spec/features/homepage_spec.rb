require 'rails_helper'

RSpec.feature 'Homepage' do
  scenario 'An anonymous user goes to the home page' do
    visit '/'

    expect(page).to have_content(/^Welcome to BMI calculator/)
    expect(page.current_path).to eq(root_path)
  end
end
