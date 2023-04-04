require "rails_helper"

RSpec.describe "Log Out User" do
	describe "log out button" do
		before do
			User.create!(name: "Bob", email: "bob@mail.com", password: "password123", password_confirmation: "password123")

			visit login_path
		end

		it "no longer has a link to log in or create an account if a user is logged in" do
			visit root_path

			expect(page).to have_link("Log In")
			expect(page).to have_button("Create New User")

			click_link "Log In"

			fill_in :email, with: "bob@mail.com"
			fill_in :password, with: "password123"
			click_button "Log In"
			visit root_path
			
			expect(page).to_not have_link("Log In")
			expect(page).to_not have_button("Create Account")
		end

		it "has a log out link only when a user is logged in" do
			expect(page).to_not have_link("Log Out")

			fill_in :email, with: "bob@mail.com"
			fill_in :password, with: "password123"
			click_button "Log In"

			expect(page).to have_link("Log Out")

			click_link "Log Out"

			expect(current_path).to eq(root_path)
			expect(page).to_not have_link("Log Out")
			expect(page).to have_link("Log In")
		end
	end
end