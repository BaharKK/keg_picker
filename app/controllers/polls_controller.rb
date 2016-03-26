class PollsController < ApplicationController
  before_filter :load_poll, only: [:show, :edit, :destroy, :update]
  authorize_resource except: [:index, :show]

  def index
    @polls = Poll.order(ended_at: :desc)
  end

  def show
  end

  def create
    Poll.create!
    flash[:success] = "You have opened a new Poll"
    redirect_to beers_path
  end

  def finalize
    poll = Poll.find(params[:poll_id])
    poll.finalize
    if poll.winner
      flash[:success] = "The Winner is found! Order your Keg!"
    else
      flash[:danger] = "There are no votes currently... :("
    end
    redirect_to polls_path
  end

  def update
    if @poll.update(update_params)
      flash[:success] = "The Poll has been updated!"
      redirect_to polls_path
    end
  end

  def destroy
    @poll.destroy!
    flash[:success] = "The Poll was deleted.."
    redirect_to polls_path
  end

  private

  def load_poll
    @poll = Poll.find(params[:id])
  end

  def update_params
    params.require(:poll).permit(:closed, :ended_at, :brewery)
  end
end
