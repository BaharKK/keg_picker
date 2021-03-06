class BallotsController < ApplicationController
  before_filter :load_beer, only: [:create]
  before_filter :load_ballot, only: [:edit, :update, :destroy]
  before_filter :load_all_beers, only: [:new, :edit, :create]
  before_filter :restrict_voting, only: [:create]
  authorize_resource

  def new
    @ballot = Ballot.new
  end

  def create
    current = Poll.current
    if current 
      @existing_ballot = current_user.ballots.find_by poll: current 
      if  @existing_ballot
        @existing_ballot.update!(beer: @beer)
      else
        current.ballots.create!(user_id: current_user.id, beer: @beer)
      end
      flash[:success] = "You have successfully voted for #{ @beer.name }"
      redirect_to root_path
    end
  end

  def update
    if @ballot.update(beer_id: params[:beer_id])
      flash[:success] = "You have changed your vote to #{ @ballot.beer.name }"
      redirect_to root_path
    end
  end

  def destroy
    @ballot.destroy!
    flash[:warning] = "Your vote was deleted.. Vote again?"
    redirect_to root_path
  end

  private

  def load_beer
    @beer = Beer.find(params[:beer_id])
  end

  def load_ballot
    @ballot = Ballot.find(params[:id])
  end

  def load_all_beers
    @beers =
      if brewery = Poll.current.brewery.presence
        Beer.where(brewery: brewery)
      else
        Beer.all
      end
  end
end
