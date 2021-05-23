extends KinematicBody2D

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

enum MOVETYPE {
	LOOP,
	WALK,
	TRANSFORM
}

export(NodePath) var target_paths
export(NodePath) var loop_path
export(int) var move_speed = 2
export(MOVETYPE) var Move_Type = MOVETYPE.LOOP
export(int) var min_patrol_point_distance = 500
var patrol_points
var patrol_index = 0
var target := Vector2.ZERO
var movement := Vector2.ZERO
var patrol_target := Vector2.ZERO
var move_direction = 0

onready var remote_transfer = get_node(str(target_paths, "/Door1TODoor2/PathFollow2D")) #str() concates the string names
onready var _animation_player = $AnimationPlayer

func _ready() -> void:
	match Move_Type:
		MOVETYPE.WALK: #If movement type is walk (Find and Go towards a destination)
			Get_Random_Path()
		MOVETYPE.LOOP: #If movement type is loop (Go in pre-determined circle)
			self.patrol_points = self.get_node(loop_path).curve.get_baked_points()
		MOVETYPE.TRANSFORM: #if movement is stopped (Don't move but transform into candy)
			pass

func _physics_process(delta: float) -> void:
	match Move_Type:
		MOVETYPE.WALK: #If movement type is walk (Go Towards Destination)
			MovementLoop(delta)
		MOVETYPE.LOOP: #If movement type is loop (go in circle)
			patrol_target = patrol_points[patrol_index]
			if position.distance_to(patrol_target) < min_patrol_point_distance:
				patrol_index = (patrol_index + 1) % patrol_points.size()
				patrol_target = patrol_points[patrol_index]

			var prepos = self.get_global_position() 		#get previous global position
			self.move_and_slide(self.position.direction_to(self.patrol_target) * self.move_speed * delta)
			var pos = self.get_global_position() 			#get new global position

			move_direction = (pos.angle_to_point(prepos) / PI)*180	#determine direction by previous->new global position
		MOVETYPE.TRANSFORM: #if movement is stopped (transforming to candy)
			pass #don't move as you are being transformed

func _process(_delta):
	if Move_Type == MOVETYPE.TRANSFORM:
		get_node("AnimationPlayer").play("Transform")
		get_node("AnimationPlayer").stop()
	else:
		AnimationLoop()
	#get_unit_offset() getter

func MovementLoop(delta):
	if (remote_transfer.get_unit_offset() < .950):   	#if not at end of loop (1.00f)
		var prepos = remote_transfer.get_global_position() 		#get previous global position
		remote_transfer.set_offset(remote_transfer.get_offset() + (move_speed/1500) + delta)
#		remote_transfer.set_offset(remote_transfer.get_offset() + move_speed + delta) 

		var pos = remote_transfer.get_global_position() 		#get new global position
		move_direction = (pos.angle_to_point(prepos) / PI)*180	#determine direction by previous->new global position
	else: ##at end so respawn
		Get_Random_Path() #get new path
		remote_transfer.set_unit_offset(0) #reset offset to 0 so start at beginning of path
			

func Get_Random_Path():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ChosenPath = rng.randi_range(3,4) #get a random integer between 0 and 2

	print("Child's ChosenPath is: ", ChosenPath)######
	match ChosenPath:
		0:
			remote_transfer = get_node (str(target_paths, "/Door1TODoor2/PathFollow2D"))
		1:
			remote_transfer = get_node (str(target_paths, "/Door1TODoor3/PathFollow2D"))
		2:
			remote_transfer = get_node (str(target_paths, "/Path2/PathFollow2D"))
		3:
			remote_transfer = get_node (str(target_paths, "/Path3/PathFollow2D"))
		4:
			remote_transfer = get_node (str(target_paths, "/Path4/PathFollow2D"))
		5:
			remote_transfer = get_node (str(target_paths, "/Path5/PathFollow2D"))
		6:
			remote_transfer = get_node (str(target_paths, "/Path6/PathFollow2D"))
		7:
			remote_transfer = get_node (str(target_paths, "/Path7/PathFollow2D"))
		8:
			remote_transfer = get_node (str(target_paths, "/Path8/PathFollow2D"))
		9:
			remote_transfer = get_node (str(target_paths, "/Path9/PathFollow2D"))


#_animation_player.play("WalkingDown") #start walking down animation
func AnimationLoop():
	if Move_Type != MOVETYPE.TRANSFORM:
		var animation_direction = "Up" #Up by default

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
	else:
		get_node("AnimationPlayer").play("Transform")
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
