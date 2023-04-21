extends Node

var music_credit : AudioStream = load("res://Sounds/BGM/Turisas - Rasputin.mp3")

const section_time = 2.0
const line_time = 0.3
const base_speed = 20
const speed_up_multiplier = 10.0
const title_color = Color.chartreuse

var scroll_speed = base_speed
var speed_up = false

onready var audio_manager = $audio_manager
onready var line = $Credits_Group/Text_Line
onready var credit_group = $Credits_Group
onready var the_end_anim = $the_end/theend_anim
onready var theend_timer = $TheEnd_Timer
onready var fade_black = $Fade_In_Black/ColorRect/anim_fade_black
var started = false
var finished = false
var the_end_showed = false

var section
var section_next = true
var section_timer = 0.0
var line_timer = 0.0
var curr_line = 0
var lines = []

var credits = [
	[
		"I Did a thing",
		"",
		"",
	],[
		"Programming",
		"",
		"",
		"YA BOI",
		"",
		"",
		"Rolling Credits by Ben Bishop (benbishopnz)",
		"",
		"",
		"Dynamic Water by Pixelipy"
	],[
		"Art",
		"",
		"",
		"A Bunch of people Right now later just me again",
		"",
		"",
		"Silver font by Poppy Works",
		"",
		"",
		"kokefont font by Nomi",
		"",
		"",
		"Questgiver font by Josephknightcom"
	],[
		"Music",
		"",
		"",
		"Title Screen:",
		"",
		"Fantasy Style Loop by jackfluck",
		"",
		"",
		"World:",
		"",
		"Fairy Tale Harps Chime by slaking-97",
		"",
		"",
		"Game Over:",
		"",
		"Wish... Dance on the Clouds from Narutimate Accel 2",
		"",
		"",
		"BOSS Theme:",
		"",
		"RPG5 by LeviathanMusic",
		"",
		"",
		"Credits:",
		"",
		"Rasputin by Turisas"
	],[
		"Sound Effects",
		"",
		"",
		"Some by:",
		"",
		"",
		"",
		"axilirate",
		"",
		"behansean",
		"",
		"christopherderp",
		"",
		"cribbler",
		"",
		"fessfessor",
		"",
		"independent.nu",
		"",
		"konstati",
		"",
		"michel88",
		"",
		"Michel Baradari",
		"",
		"qubodup",
		"",
		"raclure",
		"",
		"sheyvan",
		"",
		"Reaper",
		"",
		"vixuxx",
		"",
		"voxartist",
		"",
		"wesleyextreme_gamer",
		"",
		"",
		"",
		"Some taken from:",
		"",
		"",
		"",
		"Marvel VS Capcom Infinite - Zero Voice and SFX",
		"",
		"Castlevania Symphony of the Night",
		"",
		"Metroid Fusion"
	]
]

func _ready():
	audio_manager.play_music(music_credit)
	theend_timer.start()

func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		the_end_anim.play("in")
		yield(get_tree().create_timer(12), "timeout")
		fade_black.play("fade-in")
		# NOTE: This is called when the credits finish
		# - Hook up your code to return to the relevant scene here, eg...
		#get_tree().change_scene("res://scenes/MainMenu.tscn")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	credit_group.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_start"):
		finish()
	if event.is_action_pressed("ui_accept") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_accept") and !event.is_echo():
		speed_up = false


func _on_TheEnd_Timer_timeout():
	if not finished:
		the_end_anim.play("in")
		yield(get_tree().create_timer(12), "timeout")
		fade_black.play("fade-in")


func _on_theend_anim_animation_finished(anim_name):
	if the_end_showed == false:
		if anim_name == "in":
			finished = true
			the_end_anim.play("full_color")
			the_end_showed = true


func _on_anim_fade_black_animation_finished(anim_name):
	if anim_name == "fade-in":
			fade_black.play("full_color")
			yield(get_tree().create_timer(1), "timeout")
			get_tree().change_scene("res://Scenes/Menu.tscn")
