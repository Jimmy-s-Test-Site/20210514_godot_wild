extends Control

export(float) var speed := 50

func _process(delta: float) -> void:
	if $Control/Label.margin_top > 0:
		$Control/Label.margin_top -= self.speed * delta
