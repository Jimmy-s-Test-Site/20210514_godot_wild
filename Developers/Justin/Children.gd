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
export(float) var min_patrol_point_distance = 2

var target := Vector2.ZERO
var movement := Vector2.ZERO

var patrol_points
var patrol_index = 0
var patrol_target := Vector2.ZERO

#var rng = RandomNumberGenerator.new()
#func _ready():
#    rng.randomize()
#    var my_random_number = rng.randf_range(-10.0, 10.0)
	

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ChosenPath = rng.randi_range(0,1) #get a random integer between 0 and 1

#	var ChosenPath = randi()%3 #get a random integer between 0 and 1
	print(ChosenPath)######
	print(self.patrol_path)######
	match ChosenPath:
		0:
			self.patrol_path="../Paths/GroceryTOClothing"
			print("Groc to Clothing")#########
			print(self.patrol_path)
		1:
			self.patrol_path="../Paths/GroceryTOHome1"
			print("Groc to Home")###########
			print(self.patrol_path)

	if self.patrol_path != null:
		self.patrol_points = self.get_node(patrol_path).curve.get_baked_points()

#	StartingDoor = randi()%9 #get a random integer between 0 and 8
#	EndingDoor = randi()%9 #get a random integer between 0 and 8

		

func animation_manager() -> void:
	var horizontal_facing_direction = sign(self.target.x)
	
	match horizontal_facing_direction:
		-1:
			$Sprite.flip_h = true
		1:
			$Sprite.flip_h = false

func _physics_process(delta: float) -> void:

	if self.patrol_path == null:
		return
	
	self.target = self.patrol_points[self.patrol_index]
	
	if self.position.distance_to(target) < 1:
		self.patrol_index = wrapi(self.patrol_index + 1, 0, self.patrol_points.size())
		self.target = self.patrol_points[self.patrol_index]
	
	self.movement = (self.target - self.position).normalized() * self.speed * delta
	self.movement = self.move_and_slide(self.movement)
