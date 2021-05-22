extends KinematicBody2D

export(NodePath) var patrol_paths
export(int) var move_speed = 2

enum DESTINATIONS { # 8 of them estimated
	CLOTHING,
	GROCERY,
	HOME1,
	HOME2,
	HOME3,
	SCHOOL,
	BUSINESS,
	BATHROOM
}

#onready var remote_transfer = get_node("../Paths/Door1TODoor2/PathFollow2D")

onready var remote_transfer = get_node(str(patrol_paths, "/Door1TODoor2/PathFollow2D"))

func _ready() -> void:
	Get_Random_Path()

var move_direction = 0

onready var _animation_player = $AnimationPlayer


func _physics_process(delta):
	MovementLoop(delta)

func _process(delta):
	AnimationLoop()
	#get_unit_offset() getter

func MovementLoop(delta):
	if (remote_transfer.get_unit_offset() < 1):   	#if not at end of loop (1.00f)
		var prepos = remote_transfer.get_global_position() 		#get previous global position
		remote_transfer.set_offset(remote_transfer.get_offset() + move_speed + delta) 
		var pos = remote_transfer.get_global_position() 		#get new global position
		move_direction = (pos.angle_to_point(prepos) / PI)*180	#determine direction by previous->new global position
	else: ##at end so respawn
		Get_Random_Path() #get new path
		remote_transfer.set_unit_offset(0) #reset offset to 0 so start at beginning of path
			

func Get_Random_Path():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ChosenPath = rng.randi_range(0,1) #get a random integer between 0 and 1

	print("Child's ChosenPath is: ", ChosenPath)######
	match ChosenPath:
		0:
			remote_transfer = get_node (str(patrol_paths, "/Door1TODoor2/PathFollow2D"))
			print("Door1->Door2")#########
		1:
			remote_transfer = get_node (str(patrol_paths, "/Door1TODoor3/PathFollow2D"))
			print("Door1->Door3")###########


#_animation_player.play("WalkingDown") #start walking down animation
func AnimationLoop():
	var animation_direction = "Up" #down by default
	if move_direction <= 60 and move_direction >= -60:
		animation_direction = "Right"
	elif move_direction <= -165 and move_direction >= -60:
		animation_direction = "Up"
	elif move_direction <= 165 and move_direction >= 60:
		animation_direction = "Down"
	elif move_direction <= -165 or move_direction >= 165:
		animation_direction = "Left"
	var animation = "Walking" + animation_direction
	get_node("AnimationPlayer").play(animation)
		
	#IN RADIANS

#	if facing_direction<(PI/4) or facing_direction<(-PI/4): 		#facing right
#		_animation_player.play("WalkingRight") #start walking down animation
#	elif facing_direction>=(PI/4) and facing_direction<=(PI*3/4):  #facing up
#		_animation_player.play("WalkingUp") #start walking down animation
#	elif facing_direction>(PI*3/4) or facing_direction>(-PI*3/4):  #facing left
#		_animation_player.play("WalkingLeft") #start walking down animation
#	elif facing_direction>=(-PI/4) and facing_direction<=(-PI*3/4):  #facing down
#		_animation_player.play("WalkingDown") #start walking down animation

	#IN DEGREES
#	if facing_direction<45 or facing_direction>315: 		#facing right
#		_animation_player.play("WalkingRight") #start walking down animation
#	elif facing_direction>=45 and facing_direction<=135:  #facing up
#		_animation_player.play("WalkingUp") #start walking down animation
#	elif facing_direction>135 and facing_direction<225:  #facing left
#		_animation_player.play("WalkingLeft") #start walking down animation
#	elif facing_direction>=225 and facing_direction<=315:  #facing down
#		_animation_player.play("WalkingDown") #start walking down animation
