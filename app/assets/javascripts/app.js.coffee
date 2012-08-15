$(document).ready -> init()

init = ->
	$("#playersNum").click -> $("#toPlayersSettings").removeAttr "disabled"
	$("#toPlayersSettings").click process_players
	$("#toClubsSettings").click process_teams
	$('body').height $(document).height()

int_where = (selector) ->
	parseInt $(selector).val(), 10

inputs_where = (selector) ->
	(n.value for n in $(selector))

toggle_boxes = (hide, show)->
	$(hide).hide "slow"
	$(show).removeClass "hidden"

process_players = ->
	clubs_num   = int_where "#clubsNum"
	players_num = int_where "#playersNum"
	if not players_num
		alert "Can't proceed to player settings with '-' selected"
		return
	else if players_num < clubs_num
 		alert "More clubs than players"
 		return
 	else
 		League.set_basic_params players_num, clubs_num
 		Display.players_input players_num
		toggle_boxes "#basicSettings", "#playersSettings"
		collect_players_names()

collect_players_names = ->
	$("#makeTeams").click ->
		League.set_players_list_to inputs_where "[name='namesOfPlayers']"
		toggle_boxes "#playersSettings", "#clubsSettings"
		$("#playersInClubs").removeClass "hidden"
		Display.teams()
		setup_clubs()

process_teams = ->
	toggle_boxes "#basicSettings", "#clubsSettings"
	clubs_num = int_where "#clubsNum"
	League.set_basic_params clubs_num, clubs_num
	League.set_players_list_to (null for i in clubs_num)
	setup_clubs()

setup_clubs = ->
	Display.clubs_input()
	$("#toLeague").click ->
		teams  = League.get_teams()
		cl_names = inputs_where "[name='namesOfClubs']"
		for i in [0...teams.length]
			teams[i].club_name = cl_names[i]
		toggle_boxes "#clubsSettings", "#league"
		Display.table()
		Display.schedule()
		play_league()

set_winner = (winner, goals) ->
	winner.wins += 1
	winner.points += 3
	winner.goals_scored += goals.reduce (x, y) -> if x >= y then x else y
	winner.goal_difference += Math.abs goals[0] - goals[1]

set_loser = (loser, goals) ->
	loser.losses += 1
	loser.goals_scored += goals.reduce (x, y) -> if x <= y then x else y
	loser.goal_difference += -1 * Math.abs goals[0] - goals[1]

set_draw = (game, goals) ->
	for team in game
		team.points += 1
		team.draws += 1
		team.goals_scored += goals

set_results = (goals, game) ->
	[home, guest] = goals
	if home > guest
		set_winner game[0], goals
		set_loser game[1], goals
	else if home < guest
		set_winner game[1], goals
		set_loser game[0], goals
	else
		set_draw game, home

play_league = ->
	schedule = League.get_schedule()
	game = 0
	$("#tableUpdate").click ->
		goals = inputs_where "input[name='res#{game}']"
		goals = (parseInt g, 10 for g in goals)
		if game == schedule.length
			alert "League is over. Refresh browser for new"
		else if isNaN(goals[0]) or isNaN(goals[1])
			alert "Enter a numbers only and don't skip games"
		else
			set_results goals, schedule[game]
			$("#leagueTable").empty()
			Display.table()
			game++			
