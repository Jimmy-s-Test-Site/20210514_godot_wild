extends KinematicBody2D

# constants

const WALK_SPEED_MAX = 250.0
const WALK_ACCELERATION = 250.0
const WALK_FRICTION = 20.0

# variables

var motion = Vector2()
var walk_motion = Vector2()

# functions

func _physics_process(delta):	
	update_walk_motion()
	
	motion = walk_motion
	motion = move_and_slide(motion)

func update_walk_motion():
	var axis = get_input_axis()
	
	if (axis.x == 0):
		walk_motion.x = lerp(walk_motion.x, 0, (WALK_FRICTION / 100.0))
	else:
		walk_motion.x = clamp((walk_motion.x + (axis.x * WALK_ACCELERATION)), -WALK_SPEED_MAX, WALK_SPEED_MAX)
		
	if (axis.y == 0):
		walk_motion.y = lerp(walk_motion.y, 0, (WALK_FRICTION / 100.0))
	else:
		walk_motion.y = clamp((walk_motion.y + (axis.y * WALK_ACCELERATION)), -WALK_SPEED_MAX, WALK_SPEED_MAX)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	axis.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return axis.normalized()
