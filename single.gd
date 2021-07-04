extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# node for each button
onready var b = get_node("info")
onready var rcam_b = get_node("rcam")
onready var aero_b = get_node("aerodas")
onready var simulink_b = get_node("simulink")
onready var modes_b = get_node("flightmodes")

func _on_back_pressed():
	get_tree().change_scene("res://splash.tscn")
	var globe = get_node("/root/global")
	globe.simple = false
	globe.rcam = false
	globe.simulink = false
	globe.modes = false
	globe.issingle = false


func _on_aerodas_pressed():
	var globe = get_node("/root/global")
	globe.issingle = true
	globe.simple = true
	get_tree().change_scene("res://rivendell.tscn")



func _on_rcam_pressed():
	var globe = get_node("/root/global")
	globe.issingle = true
	globe.rcam = true
	get_tree().change_scene("res://rivendell.tscn")


func _on_simulink_pressed():
	var globe = get_node("/root/global")
	globe.issingle = true
	globe.simulink = true
	get_tree().change_scene("res://rivendell.tscn")


func _on_flightmodes_pressed():
	var globe = get_node("/root/global")
	globe.issingle = true
	globe.modes = true
	get_tree().change_scene("res://rivendell.tscn")


func _on_rcam_mouse_entered():
	#var box = get_node("info")
	b.text = "A 6DOF non-linear model which implements both forces and moments. \nConnect the simulator to your controller and use gamepad-tools for settings."
	b.visible = true
	rcam_b.rect_size.x +=20
	rcam_b.rect_size.y += 20
	#rcam_b.text = "information about the rcam model thing and etc"


func _on_rcam_mouse_exited():
	rcam_b.rect_size.x -= 20
	rcam_b.rect_size.y -= 20
	b.visible = false


func _on_aerodas_mouse_entered():
	aero_b.rect_size.x += 20
	aero_b.rect_size.y += 20
	b.text = "A simple, force-only model with AERODAS post-stall modelling\nPress the TAB key for controls.\nThis model can be controlled directly with the keyboard"
	b.visible = true
	

func _on_aerodas_mouse_exited():
	aero_b.rect_size.x -= 20
	aero_b.rect_size.y -= 20
	b.visible = false


func _on_simulink_mouse_entered():
	b.text = "An integration with MATLAB simulink. Demo of drone from Simulink\nNote : This model requires few software dependencies. Please ensure its installed before trying.\nFor set-up instructions, kindly refer to\nhttps://github.com/sgt-miller/rfs/README.md"
	simulink_b.rect_size.x += 20
	simulink_b.rect_size.y += 20
	b.visible = true


func _on_simulink_mouse_exited():
	simulink_b.rect_size.x -= 20
	simulink_b.rect_size.y -= 20
	b.visible = false


func _on_flightmodes_mouse_entered():
	b.text = "Viualize various flight dynamics modes in 3d"
	modes_b.rect_size.x += 20
	modes_b.rect_size.y += 20
	b.visible = true


func _on_flightmodes_mouse_exited():
	modes_b.rect_size.x -= 20
	modes_b.rect_size.y -= 20
	b.visible = false
