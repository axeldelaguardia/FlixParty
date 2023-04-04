require "rails_helper"

RSpec.describe "Logging In as a Registered User" do
	describe "Link in root path" do
		it "I see a link to log in in root path" do
			visit root_path

			expect(page).to have_link "Log In"

			click_link "Log In"

			expect(current_path).to eq(login_path)
		end
	end

	describe "Log In Form" do
		before do
			visit login_path
		end

		it "I see a form to log in" do
			expect(page).to have_field(:email)
			expect(page).to have_field(:password)
		end

		it "lets user log in" do
			User.create(name: "John Doe", email: "jd@gmail.com", password: "password", password_confirmation: "password")

			fill_in :email, with: "jd@gmail.com"
			fill_in :password, with: "password"
			click_button "Log In"

			expect(current_path).to eq(user_path)
		end

		it "does not let user log in if email is invalid" do
			User.create(name: "John Doe", email: "jd@gmail.com", password: "password", password_confirmation: "password")

			fill_in :email, with: "dj@gmail.com"
			fill_in :password, with: "password"
			click_button "Log In"
			
			expect(current_path).to eq(login_path)
			expect(page).to have_content("Email or password is invalid")
		end

		it "does not let user log in if password is invalid" do
			User.create(name: "John Doe", email: "jd@gmail.com", password: "password", password_confirmation: "password")

			fill_in :email, with: "jd@gmail.com"
			fill_in :password, with: "password1"
			click_button "Log In"
			
			expect(current_path).to eq(login_path)
			expect(page).to have_content("Email or password is invalid")

		end
	end
end