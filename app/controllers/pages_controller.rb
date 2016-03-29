class PagesController < ApplicationController
  def home
    @poll = Poll.ongoing.last
    if current_user
      @existing_ballot = current_user.ballots.find_by poll: @poll 
    end
  end
end
