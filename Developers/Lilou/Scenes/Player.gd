extends KinematicBody2D;

# constants

const WALK_SPEED_MAX = 300.0;
const WALK_ACCELERATION = 2000.0;
const WALK_FRICTION = 20.0;

# variables

var velocity = Vector2.ZERO;

# functions

func _physics_process(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	input_vector = input_vector.normalized();
	
	if (input_vector != Vector2.ZERO):
		velocity += input_vector * WALK_ACCELERATION * delta;
		velocity = velocity.clamped(WALK_SPEED_MAX * delta);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, (WALK_FRICTION * delta));
	
	move_and_collide(velocity);
