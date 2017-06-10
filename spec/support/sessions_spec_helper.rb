module SessionsSpecHelper
  def login(email, password)
    logout

    visit '/login'

    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password

    click_button 'Log in'
  end

  def logout
    visit '/logout'
  end

  def signup(name, email, password, password_confirmation)
    logout

    visit '/signup'

    fill_in 'user[name]', with: name
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password_confirmation

    click_button 'Sign up'
  end
end
