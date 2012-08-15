window.Display = {

	append_to: (selector, item, times=1) ->
		$(selector).append $(item) for i in [0...times]

	players_input: (times) ->
		field = "<li><input type='text' name='namesOfPlayers' /></li>"
		@append_to "#playersList", field, times


	clubs_input: -> 
		field = "<li><input type='text' name='namesOfClubs' /></li>"
		@append_to "#clubsList", field, League.get_teams().length

	teams: ->
		teams = League.get_teams()
		for team in teams
			players = ("<li><i class='icon-star'></i> #{player}</li>" for player in team.players).join ''
			@append_to "#teamsList", "<li><ul>#{players}</ul></li>"

	table: ->
		teams = League.get_teams()
		for team in teams
			name  = "<td>#{team.club_name}</td>"
			wins  = "<td>#{team.wins}</td>"
			draws = "<td>#{team.draws}</td>"
			loss  = "<td>#{team.losses}</td>"
			gs    = "<td>#{team.goals_scored}</td>"
			gd    = "<td>#{team.goal_difference}</td>"
			pts   = "<td>#{team.points}</td>"
			tdata = [name, wins, draws, loss, gs, gd, pts].join ""
			@append_to "#leagueTable", "<tr id='#{team.club_name}'></tr>"
			@append_to "##{team.club_name}", tdata
		$("tr:even").css "background-color", "#eee"

	schedule: ->
		schedule = League.get_schedule()
		for i in [0...schedule.length]
			team1   = schedule[i][0].club_name
			team2   = schedule[i][1].club_name
			num     = "<td>#{i+1}</td>"
			teams   = "<td>#{team1} - #{team2}</td>"
			res_box = "<input type='text' name='res#{i}' size='1' />"
			result  = "<td>#{res_box} : #{res_box}</td>"
			@append_to "#scheduleTable", "<tr id='game#{i}'></tr>"
			@append_to "#game#{i}", [num, teams, result].join ""
		$("tr:even").css "background-color", "#eee"
		$('body').height $(document).height()
}
