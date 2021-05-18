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

export(DESTINATIONS) var StartingDoor
export(DESTINATIONS) var EndingDoor

export(int) var speed = 2000

var target := Vector2.ZERO
var movement := Vector2.ZERO
