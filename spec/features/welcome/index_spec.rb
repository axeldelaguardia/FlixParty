require 'rails_helper'

describe "Welcome Index Page" do
	describe "as a visitor" do
		it "can see a welcome message" do
			visit root_path
	
			expect(page).to have_content("Welcome to Viewing Party")
		end
	
		it "can see a button to create a new user" do
			visit root_path
	
			expect(page).to have_button("Create New User")
		end
	
		it "has a link to return to the welcome page" do
			visit root_path
	
			expect(page).to have_link("Viewing Party")
		end

		it "does not show a section of the page that lists existing users" do
			user_1 = User.create(name: "Bob", email: "bob@myemail.com", password: "securepassword", password_confirmation: "securepassword")
			user_2 = User.create(name: "Sally", email: "sally@myemail.com", password: "securepassword", password_confirmation: "securepassword")  

			visit root_path

			expect(page).to_not have_content("Users")
			expect(page).to_not have_content(user_1.name)
		end
	end

	describe "as a registered user" do
		it "shows a list of all users" do
			user_1 = User.create(name: "Bob", email: "bob@myemail.com", password: "securepassword", password_confirmation: "securepassword")
			user_2 = User.create(name: "Sally", email: "sally@myemail.com", password: "securepassword", password_confirmation: "securepassword")  
			
			visit root_path

			within ".navbar" do
				expect(page).to_not have_content("Users")
				expect(page).to_not have_content(user_1.name)
			end

			visit login_path

			fill_in :email, with: user_1.email
			fill_in :password, with: user_1.password
			click_button "Log In"

			within ".navbar" do
				expect(page).to have_content("Users")
				expect(page).to have_content(user_1.email)
				expect(page).to have_content(user_2.email)
				expect(page).to_not have_content(user_1.name)
				expect(page).to_not have_link(user_1.name)
				expect(page).to_not have_link(user_2.email)
			end
		end
	end
end