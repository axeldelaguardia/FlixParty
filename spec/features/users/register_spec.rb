require "rails_helper"

describe 'register page', :vcr do
	before do
		visit register_path
	end

	describe "there is a form to create a new user" do
		it "has the form" do
			expect(page).to have_field("Name")
			expect(page).to have_field("Email")
			expect(page).to have_field("Password")
			expect(page).to have_field("Password Confirmation")
			expect(page).to have_button("Register")
		end
		
		it "can register a new user" do
			fill_in "Name", with: "John Doe"
			fill_in "Email", with: "johndoe@email.com"
			fill_in :user_password, with: "password"
			fill_in :user_password_confirmation, with: "password"
			click_button "Register"
			
      user = User.find_by(email: "johndoe@email.com")
			expect(current_path).to eq(user_path(user))
		end
	end

	describe "registering with password" do
		it "there is a form to fill in name, email, password, and pasword confirmation" do
			visit register_path

			within "#register_form" do
				fill_in "Name", with: "John Doe"
				fill_in "Email", with: "johndoe@mail.com"
				fill_in :user_password, with: "password"
				fill_in :user_password_confirmation, with: "password"
				click_on "Register"
			end

			expect(current_path).to eq(user_path(User.last))
		end
	end

	describe "sad path" do
		it "will not allow a user to create account if email is invalid" do
			fill_in "Name", with: "John Doe"
			fill_in "Email", with: "johndoe"
			fill_in :user_password, with: "password"
			fill_in :user_password_confirmation, with: "password"
			click_button "Register"
			
			expect(current_path).to eq(register_path)
			expect(page).to have_content("Email is invalid")
		end

		it "will not allow user to create an account if password and password confirmation do not match" do
			fill_in "Name", with: "John Doe"
			fill_in "Email", with: "jd@email.com"
			fill_in :user_password, with: "password"
			fill_in :user_password_confirmation, with: "password1"
			click_button "Register"

			expect(current_path).to eq(register_path)
			expect(page).to have_content("Password confirmation doesn't match Password")
		end

		it "will not allow user to create an account if the email has already been taken" do
			User.create(name: "John Doe", email: "jd@email.com", password: "password", password_confirmation: "password")

			fill_in "Name", with: "John Doe"
			fill_in "Email", with: "jd@email.com"
			fill_in :user_password, with: "password"
			fill_in :user_password_confirmation, with: "password"
			click_button "Register"

			expect(current_path).to eq(register_path)
			expect(page).to have_content("Email has already been taken")
		end

		it "will not allow user to create an account if name is blank" do
			fill_in "Email", with: "jd@email.com"
			fill_in :user_password, with: "password"
			fill_in :user_password_confirmation, with: "password"
			click_button "Register"

			expect(current_path).to eq(register_path)
			expect(page).to have_content("Name can't be blank")
		end

		it "will not allow user to create an account if no password was entered" do
			fill_in "Name", with: "John Doe"
			fill_in "Email", with: "jd@email.com"
			click_button "Register"

			expect(current_path).to eq(register_path)
			expect(page).to have_content("Password can't be blank")
		end

		it "will not allow user to create an account if no password confirmation was entered" do
			fill_in "Name", with: "John Doe"
			fill_in "Email", with: "jd@email.com"
			fill_in :user_password, with: "password"

			click_button "Register"

			expect(current_path).to eq(register_path)
			expect(page).to have_content("Password confirmation doesn't match Password")
		end
	end
end