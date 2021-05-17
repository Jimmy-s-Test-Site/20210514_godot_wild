extends KinematicBody2D

enum STATE {
	ROAM,
	CHASE
}

export(int) var speed = 8000
export(NodePath) var player_path

onready var player : Node2D = self.get_node_or_null(self.player_path)
onready var state : int = STATE.ROAM

var target := Vector2.ZERO
var movement := Vector2.ZERO


func _physics_process(delta: float) -> void:
	match self.state:
		STATE.ROAM:
			pass
		STATE.CHASE:
			self.move_and_slide((self.target * self.speed * delta).normalized())


func _on_Area2D_body_entered(body: Node) -> void:
	print("entered :P")
	if self.player != null:
		self.target = self.global_position.direction_to(self.player.global_position)
		self.state = STATE.CHASE
	else:
		self.target = Vector2.ZERO
		self.state = STATE.ROAM


func _on_Area2D_body_exited(body: Node) -> void:
	self.target = Vector2.ZERO
	self.state = STATE.ROAM
