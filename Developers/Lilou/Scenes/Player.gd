extends KinematicBody2D;

# instance variables

export (float) var walk_speed_max = 300.0;
export (float) var walk_acceleration = 2000.0;
export (float) var walk_friction = 20.0;

# variables

var velocity = Vector2.ZERO;

# functions

func _physics_process(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	input_vector = input_vector.normalized();
	
	if (input_vector == Vector2.ZERO):
		velocity = velocity.move_toward(Vector2.ZERO, (walk_friction * delta));
	else:
		velocity += input_vector * walk_acceleration * delta;
		velocity = velocity.clamped(walk_speed_max * delta);
	
	move_and_collide(velocity);
