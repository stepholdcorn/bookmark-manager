require 'spec_helper'

feature "Uses browses the list of links" do
  before(:each) {Link.create(title: "Makers Academy", url: "http://www.makersacademy.com")}

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end
  
end