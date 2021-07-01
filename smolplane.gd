extends KinematicBody
#multiplayer
puppet var slave_transform= Transform()

var socket; 
var playerID = ""
var velocity = Vector3(0,0,0)
func _ready():
	socket = PacketPeerUDP.new()
	socket.listen(4242,"127.0.0.1")
	translation = Vector3(0,1000,-2000)
	if is_network_master(): 
		$Camera.set_current(true)

func _process(delta):
	if Input.is_action_just_pressed("ui_reset"): #does this work in multiplayer?
		get_tree().reload_current_scene()
	$"../HUD/fps_count".text = "FPS : " +  str(Engine.get_frames_per_second()) 
	
var lol
var ve;   
var data
func _physics_process(delta):
	if is_network_master(): 
		lol = socket.get_available_packet_count()
		if( lol > 0) :
			while (lol > 5):
				data = socket.get_packet().get_string_from_ascii()
				lol = socket.get_available_packet_count()
			data = socket.get_packet().get_string_from_ascii()
			$"../HUD/aoa".text = str(lol);
			$"../HUD/thrust".text = data
			ve = data.split_floats(',', true)
#			transform.origin.z = ve[0]
#			transform.origin.x = -ve[1]
#			transform.origin.y = 3000 - ve[2]
			velocity.z = ve[0]
			velocity.x = -ve[1]
			velocity.y = -ve[2]
			rotation.y = -ve[5]
			rotation.x = -ve[4]
			rotation.z = ve[3]
			

		move_and_slide(velocity, Vector3(0,1,0))
		transform = transform.orthonormalized() 
		rset_unreliable("slave_transform", transform) # you on this local machine is telling everyone else's representation of YOU, that YOU are moving		
	else: # We are not controlling! This is a representation of this other player
		transform = slave_transform
	
		
	
