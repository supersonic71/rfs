extends KinematicBody
#multiplayer
puppet var slave_transform= Transform()
var file = File.new()
var socket; 
var playerID = ""
var velocity = Vector3(0,0,80)
func _ready():
	var globe = get_node("/root/global")
	if globe.isrolling:
		file.open("res://rolling.csv",file.READ)
	if globe.isdutch:
		file.open("res://dutch.csv",file.READ)
	if globe.isspiral:
		file.open("res://spiral.csv",file.READ)
	if globe.isphugoid:
		file.open("res://phugoid.csv",file.READ)
	if globe.isshort:
		file.open("res://short.csv",file.READ)
	#socket = PacketPeerUDP.new()
	#socket.listen(4242,"127.0.0.1")
	translation = Vector3(0,1000,-2000)
	if is_network_master(): 
		$Camera.set_current(true)
var ve = [0,0,0,0]
var dir = Vector3(0,0,0)

func _process(delta):
	#var file = File.new()
	#file.open("res://lateral.csv")
	var globe = get_node("/root/global")
	if !file.eof_reached():
		var csv = file.get_csv_line()
		if csv.size() ==4: # 4 values are present
			#TODO:: ALIGN THE DATA TO THEIR RESPECTIVE POSITIONS
			#$"../HUD/thrust".visible = true
			$"../HUD/thrust".text = str(csv[0]) + str(csv[1]) + str(csv[2]) + str(csv[3])	
			if globe.isrolling || globe.isspiral || globe.isdutch:
				dir = get_transform().basis.x
				velocity = -dir*float(csv[0]) + get_transform().basis.z*80
				rotation.z = float(csv[2])
				rotation.y= rotation.y + float(csv[3]) * -delta
			else:
				dir = get_transform().basis.z
				velocity = dir*80
				rotation.x = float(csv[3])*.5
	if Input.is_action_just_pressed("ui_reset"): #does this work in multiplayer?
		get_tree().reload_current_scene()
	$"../HUD/fps_count".text = "FPS : " +  str(Engine.get_frames_per_second()) 
	
	move_and_slide(velocity, Vector3(0,1,0))


func clear_modes():
	var globe = get_node("/root/global")
	globe.isrolling = false
	globe.isdutch = false
	globe.isspiral = false
	globe.isphugoid = false
	globe.isshort = false
	
func _on_roll_pressed():
	clear_modes()
	var globe = get_node("/root/global")
	globe.isrolling = true
	get_tree().reload_current_scene()


func _on_dutch_pressed():
	clear_modes()
	var globe = get_node("/root/global")
	globe.isdutch = true
	get_tree().reload_current_scene()


func _on_spiral_pressed():
	clear_modes()
	var globe = get_node("/root/global")
	globe.isspiral = true
	get_tree().reload_current_scene()


func _on_phugoid_pressed():
	clear_modes()
	var globe = get_node("/root/global")
	globe.isphugoid = true
	get_tree().reload_current_scene()


func _on_short_pressed():
	clear_modes()
	var globe = get_node("/root/global")
	globe.isshort = true
	get_tree().reload_current_scene()
