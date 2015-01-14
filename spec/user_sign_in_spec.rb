require 'user'

feature "User signs in" do

	before(:each) do
		User.create(email: "test@test.com",
					password: 'test',
					password_confirmation: 'test')
	end

	scenario 'with correct credentials' do
		visit '/'
		expect(page).not_to have_content("Welcome test@test.com")
		sign_in("test@test.com", 'test')
		expect(page).to have_content("Welcome test@test.com")
	end

	scenario 'with incorrect credentials' do
		visit '/'
		expect(page).not_to have_content("Welcome test@test.com")
		sign_in("test@test.com", 'test failed')
		expect(page).not_to have_content("Welcome test@test.com")
	end

	before(:each) do
      User.create(email: "test@test.com",
      password: "test",
      password_confirmation: "test")
  end

  scenario "while being signed in" do
    sign_in("test@test.com","test")
    click_button('Sign out')
    expect(page).to have_content("Goodbye!")
    expect(page).not_to have_content("Welcome test@test.com")
  end


	def sign_in(email, password)
		visit '/sessions/new'
		fill_in 'email', with: email
		fill_in 'password', with: password
		click_button 'Sign in'
	end

end