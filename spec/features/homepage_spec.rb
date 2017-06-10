RSpec.feature 'Homepage' do
  scenario 'An anonymous user goes to the home page' do
    logout

    visit '/'

    expect(page.first('p.block.regular').text).to eq('Please log in to calculate your BMI')
    expect(page.current_path).to eq(root_path)
  end

  scenario 'A logged in user goes to to the home page' do
    email = 'buddy@example.com'
    password = 'somepass'

    signup('Buddy Tester', email, password, password)
    login(email, password)

    visit '/'

    expect(page.first('p.block.regular').text).to eq('Enter your information to calculate your BMI')
  end
end
