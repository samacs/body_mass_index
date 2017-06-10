feature 'Login page' do
  scenario 'An anonymous user goes to the log in page' do
    visit '/login'

    expect(page).to have_content('Log in')
    expect(page.current_path).to eq(login_path)
  end

  feature 'Log in process' do
    scenario 'A user submits the log in form with no information' do
      visit '/login'

      click_button 'Log in'

      expect(page).to have_content('User not found')
      expect(page.current_path).to eq(login_path)
    end

    scenario 'A registered user submits the log in form with no password' do
      email = 'buddy@example.com'
      signup('Buddy', email, 'somepass', 'somepass')

      visit '/login'

      fill_in 'user[email]', with: email

      click_button 'Log in'

      expect(page).to have_content('Wrong password')
    end

    scenario 'A registered user submits the log in form with a wrong password' do
      email = 'buddy@example.com'
      password = 'somepass'
      signup('Buddy', email, password, password)

      visit '/login'

      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: 'wrongpass'

      click_button 'Log in'

      expect(page).to have_content('Wrong password')
    end

    scenario 'A registered user submits the log in form with the correct parameters' do
      logout
      email = 'buddy@example.com'
      password = 'somepass'

      signup('Buddy Tester', email, password, password)

      visit '/login'

      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password

      click_button 'Log in'

      expect(page.current_path).to eq(root_path)
      expect(page).to have_content('Welcome to BMI calculator')
    end

    scenario 'A logged in user goes to the log in page' do
      logout

      email = 'buddy@example.com'
      password = 'somepass'

      signup('Buddy Tester', email, password, password)

      login(email, password)

      visit '/login'

      expect(page.current_path).to eq(root_path)
    end
  end
end
