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

var target := Vector2.ZERO
var movement := Vector2.ZERO

var patrol_points
var patrol_index = 0

func _ready() -> void:
	var ChosenPath = randi()%2 #get a random integer between 0 and 1
	match ChosenPath:
		1:patrol_path="../Paths/GroceryTOClothing"
			
		2:patrol_path="../Paths/GroceryTOHome1"
		
	if self.patrol_path != null:
		self.patrol_points = self.get_node(patrol_path).curve.get_baked_points()

#	StartingDoor = randi()%9 #get a random integer between 0 and 8
#	EndingDoor = randi()%9 #get a random integer between 0 and 8

		

func _physics_process(delta: float) -> void:

	if self.patrol_path == null:
		return
	
	self.target = self.patrol_points[self.patrol_index]
	
	if self.position.distance_to(target) < 1:
		self.patrol_index = wrapi(self.patrol_index + 1, 0, self.patrol_points.size())
		self.target = self.patrol_points[self.patrol_index]
	
	self.movement = (self.target - self.position).normalized() * self.speed * delta
	self.movement = self.move_and_slide(self.movement)
