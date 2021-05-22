extends KinematicBody2D

export(NodePath) var patrol_path
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

onready var remote_transfer = get_node("../../Paths/Door1TODoor2/PathFollow2D")

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ChosenPath = rng.randi_range(0,1) #get a random integer between 0 and 1

	print("ChosenPath is: ", ChosenPath)######
	match ChosenPath:
		0:
			remote_transfer = get_node("../../Paths/Door1TODoor2/PathFollow2D")
			print("Door1->Door2")#########
		1:
			remote_transfer = get_node("../../Paths/Door1TODoor3/PathFollow2D")
			print("Door1->Door3")###########

export(int) var speed = 2
var move_direction = 0

onready var _animation_player = $AnimationPlayer


func _physics_process(delta):
	MovementLoop(delta)

func _process(delta):
	AnimationLoop()

func MovementLoop(delta):
	var prepos = remote_transfer.get_global_position()
	remote_transfer.set_offset(remote_transfer.get_offset() + speed + delta)
	var pos = remote_transfer.get_global_position()
	move_direction = (pos.angle_to_point(prepos) / PI)*180
	
#_animation_player.play("WalkingDown") #start walking down animation
func AnimationLoop():
	var animation_direction = "Up" #down by default
	print("move_direction: ",move_direction)
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
