extends KinematicBody2D

enum STATE {
	ROAM,
	CHASE
}

export(NodePath) var patrol_path
export(NodePath) var player_path
export(int) var speed = 8000

onready var player : Node2D = self.get_node_or_null(self.player_path)
onready var state : int = STATE.ROAM

var attacking := false
var target := Vector2.ZERO
var movement := Vector2.ZERO

var patrol_points
var patrol_index = 0

func _ready() -> void:
	if self.patrol_path != null:
		self.patrol_points = self.get_node(patrol_path).curve.get_baked_points()

func _physics_process(delta: float) -> void:
	match self.state:
		STATE.ROAM:
			if self.patrol_path == null:
				return
			
			self.target = self.patrol_points[self.patrol_index]
			
			if self.position.distance_to(target) < 1:
				self.patrol_index = wrapi(self.patrol_index + 1, 0, self.patrol_points.size())
				self.target = self.patrol_points[self.patrol_index]
			
			self.movement = (self.target - self.position).normalized() * self.speed * delta
			self.movement = self.move_and_slide(self.movement)
		
		STATE.CHASE:
			self.target = self.global_position.direction_to(self.player.global_position)
			self.move_and_slide(self.target * self.speed * delta)


func _on_Area2D_body_entered(body: Node) -> void:
	if $InitTimer.is_stopped():
		if self.player != null:
			self.state = STATE.CHASE
		else:
			self.state = STATE.ROAM


func _on_Area2D_body_exited(body: Node) -> void:
	self.target = Vector2.ZERO
	self.state = STATE.ROAM


func _on_AttackArea2D_body_entered(body: Node) -> void:
	if $InitTimer.is_stopped():
		self.attacking = true


func _on_AttackArea2D_body_exited(body: Node) -> void:
	self.attacking = false

