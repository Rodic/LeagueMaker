window.League = (->
	players_list = []
	teams_list   = []
	schedule     = []
	clubs_num    = null
	players_num  = null

	swap_in = (arr, p1, p2) ->
		temp    = arr[p1]
		arr[p1] = arr[p2]
		arr[p2] = temp

	remove_from = (arr, item) ->
		item_i = arr.indexOf item
		arr.splice item_i if item_i isnt -1

	divide_players = ->
		teams_list = ([] for _ in [1..clubs_num])
		for i in [0...players_list.length]
			teams_list[ i%clubs_num ].push players_list[i]

	make_teams = ->
		divide_players()
		for i in [0...clubs_num]
			teams_list[i] = new Team(teams_list[i])

	fact = (n) ->
		(n is 0 or n is 1) or n * fact n-1

	fisher_yates_on = (list) ->
		for i in [list.length-1..1]
			j = Math.floor Math.random() * (i + 1)
			swap_in list, i, j

	rotate_teams_in = (teams) ->
		# rotate all but first element clock-wise
		swap_in teams, i, i-1 for i in [2...teams.length]
		
	pairs_from = (teams) ->
		return [] if teams.length is 0
		[first, middle..., last] = teams
		if "fake" in [first, last]
			pairs_from middle
		else
			[[first, last]].concat pairs_from middle

	change_host = ->
		for i in [0...schedule.length]
			swap_in schedule[i], 0, 1 if i < schedule.length/2

	round_robin_tournament = ->
		n = teams_list.length
		num_of_games = fact(n) / fact(n-2)
		teams_list.push "fake" if n % 2 isnt 0
		while schedule.length < num_of_games
			schedule = schedule.concat pairs_from teams_list
			rotate_teams_in teams_list
		change_host()
		remove_from teams_list, "fake"

	{
		set_basic_params: (p, c) ->
			players_num = p
			clubs_num   = c

		set_players_list_to: (players) -> 
			players_list = players
			fisher_yates_on players_list

		get_teams: ->
			if players_list.length is 0 or null in [clubs_num, players_num]
				alert "Set basic params first"
			else
				if teams_list.length is 0
					teams_list = make_teams()
				teams_list.sort Team.comparator

		get_schedule: ->
			if teams_list.length is 0
				alert "Make teams first"
				return
			if schedule.length is 0
				round_robin_tournament()
			schedule
	}
)()
