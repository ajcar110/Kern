extends Node

var dic : Dictionary = {}

func play_sfx(audio_clip : AudioStream, priority : int = 0):
	for child in $sfx.get_children():
		if child.playing == false:
			child.stream = audio_clip
			child.play()
			dic[child.name] = priority
			break
	
		if child.get_index() == $sfx.get_child_count() - 1:
#			var priority_player = check_priority(dic, priority) #finds the player with the highest priority
#			var priority_player = find_oldest_player() #finds the oldest player
			var priority_player = check_priority_and_find_oldest(dic, priority) #finds player with same/lowest priority and oldest player
			if priority_player != null:
				$sfx.get_node(priority_player).stream = audio_clip
				$sfx.get_node(priority_player).play()
			else:
				print("priority player is null")
	pass

#playes at most 3 sounds at the same time, in a lot of cases bad, because you get less sound feedback.
#execept when you want to restrict the amount of sounds, for example crashes/destructions/debris
func check_priority(_dic : Dictionary, _priority):
	var prio_list : Array = []
	
	for key in _dic:
		if _priority > _dic[key]:
			prio_list.append(key)#append key(sfx_player.name) to the array
	
	#get the lowest priority from prio_list
	var last_prio = null
	for key in prio_list:
		if last_prio == null:
			last_prio = key
			continue
		if _dic[key] < _dic[last_prio]:
			last_prio = key
	return last_prio
	pass

#playes new sounds all the time, bad if you have important sound, wich you liked to play
func find_oldest_player():
	var last_child = null
	
	for child in $sfx.get_children():
		if last_child == null:
			last_child = child
			continue
		#find player wich played the longest
		if child.get_playback_position() > last_child.get_playback_position():
			last_child = child
	
	return last_child.name
	pass
	
#good for all types of situations, important sound get played most of the time and sounds doesn't get get
#swallowed up most of the time
func check_priority_and_find_oldest(_dic, _priority): #1,3,1 == 1
	var prio_list : Array = []
	for key in _dic: 
		if _priority >= _dic[key]:
			prio_list.append(key) #append key(sfx_player.name) with same/lower priority to an array
	
	#find oldest 
	if prio_list.empty():
		return null
	var oldest_player = prio_list[0]
	for i in range(1, prio_list.size() -1):
		if $sfx.get_node(oldest_player).get_playback_position() < $sfx.get_node(prio_list[i]).get_playback_position():
			oldest_player = prio_list[i]

	return oldest_player
	pass
	
	###### Here is a little coding challenge  #######
#func lowest_priority_and_oldest(_dic, _priority):
	#make prio_list
	#append same/lower priority to prio_list
	#get the lowest priority
	#get all player with the same lowest priority
	#if there is more then 1 player
	#get the oldest player from the lowest priority players

func play_music(music_clip : AudioStream):
	$music/music_player.stream = music_clip
	$music/music_player.play()
	pass

func stop_music(music_clip : AudioStream):
	$music/music_player.stream = music_clip
	$music/music_player.stop()
	pass

func stop_sfx(audio_clip : AudioStream):
	for child in $sfx.get_children():
		if child.playing == true:
			child.stream = audio_clip
			child.stop()
	pass
