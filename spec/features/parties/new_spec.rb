require "rails_helper"

describe "Parties New Page", :vcr do
  before(:each) do
    @user_1 = User.create!(name: "Bob", email: "bob@myemail.com", password: "securepassword", password_confirmation: "securepassword")
    @user_2 = User.create!(name: "Lisa", email: "lisa@myemail.com", password: "securepassword", password_confirmation: "securepassword")
    @user_3 = User.create!(name: "Sally", email: "sally@myemail.com", password: "securepassword", password_confirmation: "securepassword")
    @user_4 = User.create!(name: "John", email: "john@myemail.com", password: "securepassword", password_confirmation: "securepassword")
    @user_5 = User.create!(name: "Joe", email: "joe@myemail.com", password: "securepassword", password_confirmation: "securepassword")
		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
		visit "/users/#{@user_1.id}/movies/278/parties/new?title=The%20Shawshank%20Redemption&runtime=147"
  end

  it "should have the movie title above the form" do
		expect(page).to have_content("The Shawshank Redemption")
  end

	it "should have the party duration with default value of movie runtime, date, start time, user checkboxes, and button to create" do
		expect(page).to have_field("Duration", with: 147)
		expect(page).to have_field("Date")
		expect(page).to have_field("Time")
		expect(page).to have_unchecked_field("Bob")
		expect(page).to have_unchecked_field("Lisa")
		expect(page).to have_unchecked_field("Sally")
		expect(page).to have_unchecked_field("John")
		expect(page).to have_button("Create Party")
	end

	it "should create a new party when the form is filled" do

		fill_in "Duration", with: 160
		fill_in "Date", with: "04/04/2023"
		fill_in "Time", with: "07:30"
		check "Lisa"
		check "Sally"
		click_button "Create Party"

		expect(current_path).to eq(user_path(@user_1))
	end

	it 'does not allow creation of party if the duration is shorter than runtime of movie' do
		fill_in "Duration", with: 130
		fill_in "Date", with: "04/04/2023"
		fill_in "Time", with: "07:30"
		check "Lisa"
		check "Sally"
		click_button "Create Party"
		
		expect(current_path).to eq(new_user_movie_party_path(@user_1, 278))
		expect(page).to have_content("Duration of Party cannot be shorter than Movie Runtime")
	end
end