RSpec.feature 'Signup page' do
  scenario 'An anonymous user goes to the sign up page' do
    visit '/signup'

    expect(page).to have_content('Sign up')
    expect(page.current_path).to eq(signup_path)
  end

  feature 'Sign up process' do
    scenario 'An anonymous user fills the sign up form without a name' do
      visit '/signup'

      fill_in 'user[name]', with: ''

      click_button 'Sign up'

      expect(page).to have_content('Name can\'t be blank')
    end

    scenario 'An anonymous user fills the sign up form without an email address' do
      visit '/signup'

      fill_in 'user[email]', with: ''

      click_button 'Sign up'

      expect(page).to have_content('Email can\'t be blank')
      expect(page).to have_content('Email does not appear to be a valid e-mail address')
    end

    scenario 'An anonymous user fills the sign up form without password' do
      visit '/signup'

      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''

      click_button 'Sign up'

      expect(page).to have_content('Password can\'t be blank')
      expect(page).to have_content('Password is too short')
    end

    scenario 'An anonymous user fills the sign up form without password confirmation' do
      visit '/signup'

      fill_in 'user[password]', with: 'somepass'
      fill_in 'user[password_confirmation]', with: ''

      expect { click_button }.not_to change { User.count }

      expect(page).to have_content('Password confirmation doesn\'t match Password')
    end

    scenario 'An anonymous user fills the sign up form with the right parameters' do
      visit '/signup'

      fill_in 'user[name]', with: 'Buddy Tester'
      fill_in 'user[email]', with: 'buddy@example.com'
      fill_in 'user[password]', with: 'somepass'
      fill_in 'user[password_confirmation]', with: 'somepass'

      expect { click_button 'Sign up' }.to change { User.count }.by(1)

      expect(page).to have_content('Welcome! You can now log in')
      expect(page.current_path).to eq(login_path)
    end

    scenario 'An already logged in user goest to sign up page' do
      user = User.first || User.create(name: 'Buddy Tester',
                                       email: 'buddy@example.com',
                                       password: 'somepass',
                                       password_confirmation: 'somepass')
      login(user.email, user.password)

      visit '/signup'

      expect(page.current_path).to eq(root_path)
    end
  end
end
