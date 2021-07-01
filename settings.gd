extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tex = get_node("info_text")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_back_pressed():
	get_tree().change_scene("res://splash.tscn")


func _on_high_mouse_entered():
	tex.text = "high performance"
	tex.visible = true


func _on_high_mouse_exited():
	tex.visible = false


func _on_medium_mouse_entered():
	tex.text = " low performance"
	tex.visible = true


func _on_medium_mouse_exited():
	tex.visible = false


func _on_screenres_mouse_entered():
	tex.text = "alter screen resoluton"
	tex.visible = true


func _on_screenres_mouse_exited():
	tex.visible = false
