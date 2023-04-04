class PartiesController < ApplicationController

	def new
		if current_user.nil?
			redirect_to user_movie_path(params[:movie_id])
			flash[:alert] = "Must be logged in to continue!"
		else
			@party = Party.new
			@movie = movie_params
			@users = User.all
		end
	end

	def create
		user = current_user
		party = Party.new(party_params)
		if !party.save
			flash[:alert] = error_message(party.errors)
			redirect_to new_user_movie_party_path(title: party.title, runtime: party.runtime, movie_id: party.movie_id, image_path: party.image_path)
		else
			UserParty.create(user: user, party: party, host: user)
			params[:party][:users].each do |user_id|
				next if user_id.empty? || user_id == user.id.to_s
				UserParty.create(user_id: user_id.to_i, party: party, host: false)
			end
			redirect_to user_path
		end
	end

  private

  def movie_params
    params.permit(:title, :runtime, :movie_id, :image_path)
  end

	def party_params
		params.require(:party).permit(:duration, :date, :time, :title, :movie_id, :image_path, :runtime)
	end
end


