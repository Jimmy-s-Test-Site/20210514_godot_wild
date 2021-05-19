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

export(NodePath) var patrol_path
#export(DESTINATIONS) var StartingDoor
#export(DESTINATIONS) var EndingDoor
export(int) var speed = 2000
export(float) var min_patrol_point_distance = 5

var target := Vector2.ZERO
var movement := Vector2.ZERO
var facing_direction

var patrol_points
var patrol_index = 0
var patrol_target := Vector2.ZERO

onready var _animation_player = $AnimationPlayer

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ChosenPath = rng.randi_range(0,1) #get a random integer between 0 and 1

	print(ChosenPath)######
	match ChosenPath:
		0:
			self.patrol_path="../Paths/Door1TODoor2"
			print("Door1->Door2")#########
		1:
			self.patrol_path="../Paths/Door1TODoor3"
			print("Door1->Door3")###########

	if self.patrol_path != null:
		self.patrol_points = self.get_node(patrol_path).curve.get_baked_points()

#func _process(delta):
#	_animation_player.play("WalkingDown") #start walking down animation
	

func _physics_process(delta: float) -> void:

	if self.patrol_path == null:
		return
	
	self.target = self.patrol_points[self.patrol_index]
	_animation_player.play("WalkingDown") #start walking down animation
		
	if self.position.distance_to(target) < self.min_patrol_point_distance: # if under 'minPatrolDistance' in pixels go to next target
		self.patrol_index = (self.patrol_index + 1) % self.patrol_points.size()
#		self.patrol_index = wrapi(self.patrol_index + 1, 0, self.patrol_points.size())
		self.target = self.patrol_points[self.patrol_index]
	
	self.movement = (self.target - self.position).normalized() * self.speed * delta
	self.move_and_slide(self.movement)

	#Change direction of sprite
#	facing_direction = -atan2(self.movement.y,self.movement.x)
	facing_direction=self.movement.angle()

	print(facing_direction)
	#IN RADIANS
	if facing_direction<(PI/4) or facing_direction<(-PI/4): 		#facing right
		_animation_player.play("WalkingRight") #start walking down animation
	elif facing_direction>=(PI/4) and facing_direction<=(PI*3/4):  #facing up
		_animation_player.play("WalkingUp") #start walking down animation
	elif facing_direction>(PI*3/4) or facing_direction>(-PI*3/4):  #facing left
		_animation_player.play("WalkingLeft") #start walking down animation
	elif facing_direction>=(-PI/4) and facing_direction<=(-PI*3/4):  #facing down
		_animation_player.play("WalkingDown") #start walking down animation

	#IN DEGREES
#	if facing_direction<45 or facing_direction>315: 		#facing right
#		_animation_player.play("WalkingRight") #start walking down animation
#	elif facing_direction>=45 and facing_direction<=135:  #facing up
#		_animation_player.play("WalkingUp") #start walking down animation
#	elif facing_direction>135 and facing_direction<225:  #facing left
#		_animation_player.play("WalkingLeft") #start walking down animation
#	elif facing_direction>=225 and facing_direction<=315:  #facing down
#		_animation_player.play("WalkingDown") #start walking down animation
