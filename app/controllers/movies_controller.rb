class MoviesController < ApplicationController
  def index
		if params[:movie_title]
    	@movies = MovieFacade.search_results(params[:movie_title])
		else
			@movies = MovieFacade.new.popular_movies
		end
    @user= current_user
  end

	def show
		@user = current_user
    @movie = MovieFacade.new.all_movie_details(params[:id])
	end
end