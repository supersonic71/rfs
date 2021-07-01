extends KinematicBody
#multiplayer
puppet var slave_transform= Transform()

var socket; 
var playerID = ""
var velocity = Vector3(0,0,0)


func _ready():
	Input.add_joy_mapping("030000006d04000015c2000010010000,Logitech Logitech Extreme 3D,platform:Linux,a:b6,b:b7,x:b8,y:b9,back:b10,start:b11,leftshoulder:b0,rightshoulder:b1,dpup:h0.4,dpdown:h0.1,dpleft:h0.2,dpright:h0.8,leftx:a0,lefty:a1,rightx:a2,righty:a3,", true)
	socket = PacketPeerUDP.new()
	socket.listen(4242,"127.0.0.1")
	translation = Vector3(0,1000,-2000)
	if is_network_master(): 
		$Camera.set_current(true)

func _process(delta):
	if Input.is_action_just_pressed("ui_reset"): #does this work in multiplayer?
		get_tree().reload_current_scene()
	$"../HUD/fps_count".text = "FPS : " +  str(Engine.get_frames_per_second()) 
	






func rcm(X, U):
	
	
	var x1 = X[0][0]; 
	var x2 = X[1][0]; 
	var x3 = X[2][0]; 
	var x4 = X[3][0]; 
	var x5 = X[4][0]; 
	var x6 = X[5][0]; 
	var x7 = X[6][0]; 
	var x8 = X[7][0]; 
	var x9 = X[8][0]; 


	var u1 = U[0][0]; 
	var u2 = U[1][0]; 
	var u3 = U[2][0]; 
	var u4 = U[3][0]; 
	var u5 = U[4][0];  


	var m = 130000.0; 

	var cbar = 6.6; 
	var lt = 24.8;
	var S = 260.0;
	var St = 64.0;

	var Xcg = 0.23*cbar; 
	var Ycg = 0.0;
	var Zcg = 0.10*cbar;
	
	var Xac = 0.12*cbar;
	var Yac = 0.0;
	var Zac = 0.0;



	var Xapt1 = 0.0;
	var Yapt1 = -7.94;
	var Zapt1 = -1.9;
	
	var Xapt2 = 0.0;
	var Yapt2 = 7.94;
	var Zapt2 = -1.9;


	var rho = 1.225; 
	var g = 9.81; 
	var depsda = .25; 
	var alpha_L0 = -11.5*PI/180; 
	var n = 5.5;
	var a3 = -768.5;
	var a2 = 609.2;
	var a1 = -155.2;
	var a0 = 15.292;
	var alpha_switch = 14.5 * (PI/180);



	var u1min = -25*PI/180; 
	var u1max = 25*PI/180;
	
	var u2min = -25*PI/180;
	var u2max = 10*PI/180;
	
	var u3min = -30*PI/180;
	var u3max = 30*PI/180;
	
	var u4min = 0.5*PI/180;
	var u4max = 10*PI/180;
	
	var u5min = 0.5*PI/180;
	var u5max = 10*PI/180;

	if(u1>u1max):
		u1 = u1max;
	elif(u1<u1min):
		u1 = u1min;
	
	
	if(u2>u2max):
		u2 = u2max;
	elif(u2<u2min):
		u2 = u2min;
	
	
	if(u3>u3max):
		u3 = u3max;
	elif(u3<u3min):
		u3 = u3min;
	

	if(u4>u4max):
		u4 = u4max;
	elif(u4<u4min):
		u4 = u4min;
	
	
	if(u5>u5max):
		u5 = u5max;
	elif(u5<u5min):
		u5 = u5min;
	



	var Va = sqrt(pow(x1,2) + pow(x2,2) + pow(x3,2)); 
	var alpha = atan2(x3,x1);
	var beta = asin(x2/Va);
	
	var Q = 0.5*rho*pow(Va,2);
	
	var wbe_b = [[x4],[x5],[x6]];
	var V_b = [[x1],[x2],[x3]];



	var CL_wb;
	if alpha <= alpha_switch:
		CL_wb = n*(alpha-alpha_L0);
	else:
		CL_wb = a3*pow(alpha,3) + a2*pow(alpha,2) + a1*alpha + a0;
	

	var epsilon = depsda*(alpha-alpha_L0);
	var alpha_t = alpha-epsilon + u2 + 1.3*x5*lt/Va;
	
	
	var yo = alpha_t*3.1*.2462
	var CL_t = yo

	var CL = CL_wb + CL_t;
	
	var CD = 0.13 + 0.07*pow((5.5*alpha + 0.654),2);
	
	
	var CY = -1.6*beta + 0.24*u3;




	var FA_s = [[-CD*Q*S],
			   [CY*Q*S],
			   [-CL*Q*S]];
	

	var C_bs = [[cos(alpha) ,0,-sin(alpha)],[0,1,0],[sin(alpha),0,cos(alpha)]];
	
	var FA_b = LinAlg.dot_mm(C_bs,FA_s); 


	var eta11 = -1.4*beta;
	var eta21 = -.59 - (3.1*(St*lt)/(S*cbar))*(alpha - epsilon);
	var eta31 = (1-alpha*(180/(15*PI)))*beta;

	var eta = [[eta11],[eta21],
			  [eta31]];
   
	var dummy = [[-11, 0, 5],[0, (-4.03*(St*pow(lt,2))/(S*pow(cbar,2))), 0],[1.7, 0, -11.5]];
	var dCMdx = LinAlg.ewise_ms_mul(dummy,(cbar/Va));

	#dCMdx = (cbar/Va)*[[-11 0 5],[0 (-4.03*(St*lt^2)/(S*cbar^2)) 0].[1.7 0 -11.5]];
	
	var dCMdu = [[-0.6, 0, 0.22],
			[0, (-3.1*(St*lt)/(S*cbar)), 0],
			[0, 0, -0.63]];
	
	var CMac_b = LinAlg.column_add(LinAlg.column_add(eta, LinAlg.dot_mm(dCMdx,wbe_b)), LinAlg.dot_mm(dCMdu,[[u1],[u2],[u3]]))

	
	
	var MAac_b = LinAlg.ewise_ms_mul(CMac_b,Q*S*cbar);



	var rcg_b = [[Xcg],[Ycg],[Zcg]];
	var rac_b = [[Xac],[Yac],[Zac]];
	var MAcg_b = LinAlg.column_add(MAac_b,LinAlg.column_cross(FA_b, LinAlg.ewise_mm_sub(rcg_b,rac_b))); # TODO:: CROSS PRODUCT 1
	
	
	
	var F1 = u4*m*g;
	var F2 = u5*m*g;
	
	var FE1_b = [[F1],[0],[0]];
	var FE2_b = [[F2],[0],[0]];
	
	var FE_b = LinAlg.column_add(FE1_b,FE2_b);


	var mew1 = [[Xcg-Xapt1],
			[Yapt1 - Ycg],
			[Zcg - Zapt1]];
			
	var mew2 = [[Xcg - Xapt2],
			[Yapt2 - Ycg],
			[Zcg - Zapt2]];
		 
	var MEcg1_b = LinAlg.column_cross(mew1,FE1_b); #todo : cross
	var MEcg2_b = LinAlg.column_cross(mew2,FE2_b); #todo : cross
	var MEcg_b = LinAlg.column_add(MEcg1_b,MEcg2_b);
	
	
	var g_b = [[-g*sin(x8)],
		   [g*cos(x8)*sin(x7)],
		   [g*cos(x8)*cos(x7)]];
	
	
	var Fg_b = LinAlg.ewise_ms_mul(g_b,m)


	
	var Ib = LinAlg.ewise_ms_mul([[40.07,0, -2.0923],[0, 64, 0],[-2.0923, 0, 99.92]],m);
	
	var invIb = LinAlg.ewise_ms_mul([[0.0249836, 0, 0.000523151],
				   [0, 0.015625, 0],
				   [0.000523151, 0, 0.010019]],1/m);
			
	
			
	var F_b = LinAlg.column_add(LinAlg.column_add(Fg_b, FE_b) , FA_b);
	var temp = 1/m;
	var dummy3 = LinAlg.column_mul(F_b,temp)
	var x1to3dot =  LinAlg.ewise_mm_sub(  dummy3 , LinAlg.column_cross(wbe_b,V_b)); #wbe_b V_b cross TODO
	
	var Mcg_b = LinAlg.column_add(MAcg_b,MEcg_b);
	var x4to6dot = LinAlg.dot_mm(invIb,LinAlg.ewise_mm_sub(Mcg_b, LinAlg.column_cross(wbe_b,LinAlg.dot_mm(Ib,wbe_b)))); #wbe_b and IB*wbe_b cross TODO
	
	
	var H_phi = [[1,sin(x7)*tan(x8), cos(x7)*tan(x8)],
			[0, cos(x7), -sin(x7)],
			[0, sin(x7)/cos(x8), cos(x7)/cos(x8)]];
		
		
	var x7to9dot = LinAlg.dot_mm(H_phi,wbe_b);
	
	
	
	
	var x1to9dot = x1to3dot+x4to6dot+x7to9dot;
	
	var C1v = [[cos(x9), sin(x9), 0],
		  [-sin(x9), cos(x9), 0],
		  [0, 0, 1]];
	
	var C21 = [[cos(x8), 0, -sin(x8)],
		 [0, 1, 0],
		 [sin(x8), 0, cos(x8)]];
	 
	var Cb2 = [[1, 0, 0],
		 [0, cos(x7), sin(x7)],
		 [0, -sin(x7), cos(x7)]];
	
	var Cbv = LinAlg.dot_mm(LinAlg.dot_mm(Cb2,C21),C1v);
	var Cvb = LinAlg.transpose(Cbv);
	
	var x10to12dot = LinAlg.dot_mm(Cvb,V_b);
	
	var XDOT = x1to9dot+x10to12dot;
	
	return XDOT
 






var lol
var ve;   
var data;
var X = [[85],[0],[0],[0],[0],[0],[0],[.1],[0],[1000],[1000],[1000]]
var U = [[0],[0],[0],[0],[0]]
var XDOT = [[85],[0],[0],[0],[0],[0],[0],[.1],[0],[1000],[1000],[1000]]
func _physics_process(delta):
	$"../HUD/aoa".visible = true
	var u1 = Input.get_joy_axis(0,0)*-25*PI/180
	var u2 = Input.get_joy_axis(0,1)*-25*PI/180 - .12
	var u3 = Input.get_joy_axis(0,2)*-30*PI/180
	var u4 = Input.get_joy_axis(0,3)*.5 + .5
	var u5 = u4;
	U = [[u1], [u2], [u3], [u4], [u5]]
	XDOT = rcm(X,U)
	X = LinAlg.ewise_mm_add(X,LinAlg.ewise_ms_mul(XDOT,delta))
	$"../HUD/aoa".text = str(XDOT)
	if is_network_master(): 
#		lol = socket.get_available_packet_count()
#		if( lol > 0) :
#			while (lol > 5):
#				data = socket.get_packet().get_string_from_ascii()
#				lol = socket.get_available_packet_count()
#			data = socket.get_packet().get_string_from_ascii()
#			#$"../HUD/aoa".text = str(lol);
#			$"../HUD/thrust".text = data
#			ve = data.split_floats(',', true)
##			transform.origin.z = ve[0]
##			transform.origin.x = -ve[1]
##			transform.origin.y = 3000 - ve[2]
		velocity.z = XDOT[9][0]
		velocity.x = -XDOT[10][0]
		velocity.y = -XDOT[11][0]
		rotation.y = -X[8][0]
		rotation.x = -X[7][0]
		rotation.z = X[6][0]
		

		move_and_slide(velocity, Vector3(0,1,0))
		transform = transform.orthonormalized() 
		rset_unreliable("slave_transform", transform) # you on this local machine is telling everyone else's representation of YOU, that YOU are moving		
	else: # We are not controlling! This is a representation of this other player
		transform = slave_transform
	
		
	
