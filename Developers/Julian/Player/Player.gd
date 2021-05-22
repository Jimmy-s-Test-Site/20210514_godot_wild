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

var can_cast = true;
var cast_hit = null;
export (float) var spell_distance_max = 350.0;
export (float) var spell_duration = 0.5;
export (float) var spell_cooldown = 0.25;
onready var spell_raycast = $Spell/RayCast;
onready var spell_line = $Spell/Line;
onready var spell_line_particles = $Spell/Line/LineParticles;
onready var spell_tween = $Spell/Tween;
onready var spell_start = $Spell/Start;
onready var spell_start_particles = $Spell/Start/StartParticles;
onready var spell_end = $Spell/End;
onready var spell_end_particles = $Spell/End/EndParticles;


# functions

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

	if (Input.is_action_just_pressed("cast_spell") and can_cast):
		cast_spell();

	if (cast_hit):
		cast_beam();


# 	state

func take_damage(amount: int = 1) -> void:
	health -= amount;


func kill() -> void:
	get_tree().reload_current_scene();


# 	abilities

func cast_spell() -> void:
	can_cast = false;

	cast_beam();

	appear();

	yield(get_tree().create_timer(spell_duration), "timeout");

	yield(get_tree().create_timer(spell_cooldown), "timeout");

	disappear();

	can_cast = true;


func cast_beam() -> void:
	# update raycast
	var cast_target = spell_raycast.get_local_mouse_position().clamped(spell_distance_max);

	# update hit
	if (spell_raycast.is_colliding()):
		cast_hit = spell_raycast.get_collider();

		if (cast_hit == self):
			cast_hit = null;
		else:
			cast_target = spell_raycast.get_collision_point();

	spell_raycast.cast_to = cast_target;
	# cast_hit = spell_raycast.is_colliding();

	# update particles
	spell_start_particles.global_rotation = spell_raycast.cast_to.angle();
	spell_end_particles.global_rotation = spell_raycast.get_collision_normal().angle();
	spell_end.global_position = to_global(cast_target);
	spell_line_particles.position = cast_target * 0.5;
	spell_line_particles.process_material.emission_box_extents.x = cast_target.length() * 0.5;
	spell_line_particles.rotation = spell_raycast.cast_to.angle();

	# update line
	spell_line.set_point_position(1, cast_target);


func appear() -> void:
	spell_line_particles.emitting = true;
	spell_start_particles.emitting = true;
	spell_end_particles.emitting = true;

	spell_tween.stop_all();
	spell_tween.interpolate_method(spell_line, "width", 0, 10.0, 0.2);
	spell_tween.start();


func disappear() -> void:
	cast_hit = null;

	spell_tween.stop_all();
	spell_tween.interpolate_method(spell_line, "width", 10.0, 0, 0.1);
	spell_tween.start();

	spell_line_particles.emitting = false;
	spell_start_particles.emitting = false;
	spell_end_particles.emitting = false;
