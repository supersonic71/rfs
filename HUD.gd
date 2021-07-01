extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var aoa = $airspeed

# Called when the node enters the scene tree for the first time.
func _ready():
		$thrust.visible = false
		$aoa.visible = false
		$fps_count.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
