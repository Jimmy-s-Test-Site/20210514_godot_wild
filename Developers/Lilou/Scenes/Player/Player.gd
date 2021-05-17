extends KinematicBody2D;

# instance variables

export (float) var walk_speed_max = 300.0;
export (float) var walk_acceleration = 2000.0;
export (float) var walk_friction = 20.0;

# class variables

# 	movement

var velocity = Vector2.ZERO;

# 	abilities

export (float) var cast_distance_max = 350.0;
export (float) var cast_time = 0.2;
onready var spell = $Spell;
onready var spell_raycast = $Spell/SpellRayCast;
onready var spell_line = $Spell/SpellRayCast/SpellLine;

# functions

func _ready():
	spell_raycast.position = Vector2(cast_distance_max, 0);

func _physics_process(delta: float) -> void:
	
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
	
	if Input.is_action_just_pressed("fire"):
		fire();

# 	abilities

func fire():
	spell.global_rotation = global_position.angle_to_point(get_global_mouse_position()) - PI;
	#spell_raycast.cast_to = get_local_mouse_position();
	#spell_raycast.cast_to = spell_raycast.cast_to.clamped(cast_distance_max);
	spell_line.clear_points();
	spell_line.add_point(Vector2.ZERO);
	spell_line.add_point(spell_raycast.cast_to);
	
	var hit = spell_raycast.get_collider();
	
	if spell_raycast.is_colliding() and hit.has_method("tranform"):
		hit.transform();
	
	yield(get_tree().create_timer(cast_time), "timeout");
	
	spell_line.clear_points();
	
# 	helpers
