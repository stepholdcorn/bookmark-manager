require 'user'

feature 'User signs up' do

  scenario 'when being a new user visiting the site' do
    expect{ sign_up }.to change(User, :count).by 1
    expect(page).to have_content("Welcome steph@gmail.com")
    expect(User.first.email).to eq "steph@gmail.com"
  end

  def sign_up(email="steph@gmail.com",password="whatever_string_you_want")
    visit '/users/new'
    expect(page.status_code).to eq 200
    fill_in :email, with: email
    fill_in :password, with: password
    click_button "Sign up"
  end
  
end