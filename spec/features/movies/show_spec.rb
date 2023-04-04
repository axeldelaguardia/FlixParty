require "rails_helper"

describe "Movie Show Page", :vcr do
	describe "movie's detail page" do
		before(:each) do
			@user_1 = User.create(name: "Bob", email: "bob@myemail.com", password: "securepassword", password_confirmation: "securepassword")
	
			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
	
			visit "/users/#{@user_1.id}/movies/278"
		end
	
		it { expect(current_path).to eq("/users/#{@user_1.id}/movies/278") }

		it "has a button to create a viewing party" do
			expect(page).to have_button("Create Viewing Party")

			click_button "Create Viewing Party"

			expect(current_path).to eq(new_user_movie_party_path(@user_1, 278))
		end

		it "has a button to return to Discovery Page" do
			expect(page).to have_button("Return to Discover Page")
			
			click_button "Return to Discover Page"

			expect(current_path).to eq(user_discover_index_path(@user_1))
		end

		it "has a title, average vote, runtimes, genres, summary, cast, total reviews, and author" do
			expect(page).to have_content("The Shawshank Redemption")
			expect(page).to have_content("Vote Average: 8.702")
			expect(page).to have_content("Runtime: 142")
			expect(page).to have_content("Genres: Drama Crime") 
			expect(page).to have_content("Summary: Framed in the 1940s for the double murder of his wife")
			expect(page).to have_content("Cast: Tim Robbins Morgan Freeman")
			expect(page).to have_content("Total Reviews: 9")
			expect(page).to have_content("Reviews: elshaarawy")
			expect(page).to have_content("very good movie 9.5/10 محمد الشعراوى")
		end
  end


	describe "creating a movie party when not logged in" do
		before(:each) do
			visit "/users/1/movies/278"
		end

		it "redirects to movie show page with a message saying you must be logged in" do
			expect(page).to_not have_content("Must be logged in to continue!")

			click_button "Create Viewing Party"
			
			expect(page).to have_content("Must be logged in to continue!")
		end
	end
end  

