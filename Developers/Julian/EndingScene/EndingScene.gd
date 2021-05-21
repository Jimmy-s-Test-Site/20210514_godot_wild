extends Control

export(float) var start_y := 2.3
export(float) var speed := 0.1

func _ready() -> void:
	$Control/Label.anchor_top = self.start_y
	$Control/Label.anchor_bottom = self.start_y

func _process(delta: float) -> void:
	$Control/Label.anchor_top -= self.speed * delta
