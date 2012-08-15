window.Team = class Team 
	constructor: (players)->
		@players = players
		@club_name = null
		@wins = 0
		@draws = 0
		@losses = 0
		@goals_scored = 0
		@goal_difference = 0
		@points = 0

	@comparator: (->
		params = ["points", "goals_scored", "goal_difference"]
		n = params.length - 1
		cmpt = (team1, team2, p=0) ->
			param = params[p]
			if p is n or team1[param] isnt team2[param]
				return team1[param] < team2[param]
			else
				cmpt(team1, team2, p+1)
		)()
