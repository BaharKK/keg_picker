class BeersController < ApplicationController
  authorize_resource
  before_action :load_beer, only: [:edit, :show, :destroy, :update]

  def index
    @beers = Beer.order(:brewery).order(:name)
  end

  def new
    @beer = Beer.new
  end

  def create
    @beer = Beer.new(beer_params)
    if @beer.save
      flash[:success] = "#{@beer.name} was added to the Beer list"
      redirect_to beers_path
    else
      flash[:danger] = "Could not add a new Beer :( Try again!"
      render :new
    end
  end

  def update
    if @beer.update(beer_params)
      flash[:success] = "You have successfully changed your Beer!"
      redirect_to beers_path
    else
      render :edit
      flash[:danger] = "Oops something went wrong.."
    end
  end

  def destroy
    @beer.destroy!
    flash[:success] = "The Beer was removed from the list"
    redirect_to beers_path
  end

  private

  def beer_params
    params.require(:beer).permit(:brewery, :name, :style)
  end

  def load_beer
    @beer = Beer.find(params[:id])
  end
end
