
class LeaguesController < ApplicationController
  def new
  	@clubs_num   = (3..12)
  	@players_num = (3..24)
  end
end
