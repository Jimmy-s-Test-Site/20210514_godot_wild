extends KinematicBody2D;

# instance variables

export (float) var walk_speed_max = 300.0;
export (float) var walk_acceleration = 2000.0;
export (float) var walk_friction = 20.0;

# class variables

# 	state

var health = 3;

# 	movement

var velocity = Vector2.ZERO;

# 	abilities

export (float) var cast_distance_max = 350.0;
export (float) var cast_time = 0.2;
onready var spell_raycast = $SpellRayCast;
onready var spell_line = $SpellRayCast/SpellLine;

# functions

#func _ready():
#	spell_raycast.cast_to = Vector2(cast_distance_max, 0);

func _physics_process(delta: float) -> void:
	
	# state update
	if (health <= 0):
		kill();
	
	# movement update
	
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
	
	# abilities update
	
	if Input.is_action_just_pressed("cast_spell"):
		cast_spell();

# 	state

func take_damage(amount: int = 1) -> void:
	health -= amount;

func kill() -> void:
	get_tree().reload_current_scene();

# 	abilities

func cast_spell():
	spell_raycast.enabled = true;
	
	var cast_line = get_global_mouse_position() - spell_raycast.global_position;
	cast_line = cast_line.clamped(cast_distance_max);
	
	spell_raycast.cast_to = cast_line;
	
	spell_line.clear_points();
	spell_line.add_point(Vector2.ZERO);
	
	if spell_raycast.is_colliding():
		spell_line.add_point(spell_raycast.get_collision_point());
	else:
		spell_line.add_point(cast_line);
	
	var hit = spell_raycast.get_collider();
	
	if (spell_raycast.is_colliding() and hit.has_method("transform")):
		hit.transform();
	
	spell_raycast.enabled = false;
	
# 	helpers
