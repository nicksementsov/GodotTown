extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var meshRotator

var cameraRotator
var cameraSpringArm
var playerCamera
var springDistance

var playerShape

var dir = Vector3()
var vel = Vector3()
const MAX_SPEED = 10
const ACCEL = 1
const DEACCEL = 5
const ROT_SPEED = 0.5
const MAX_SLOPE_ANGLE = 50
const GRAVITY = 27.0

var health = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	meshRotator = $MeshRotator
	
	cameraRotator = $CameraRotator
	cameraSpringArm = $CameraRotator/SpringArm
	playerCamera = $CameraRotator/SpringArm/Camera
	springDistance = 15
	cameraSpringArm.spring_length = springDistance
	cameraSpringArm.rotation_degrees = Vector3(-45, -45, 0)
	playerShape = $CollisionShape
	hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input(delta)
	process_movement(delta)
	
func start(startPosition, startRotation):
	set_translation(startPosition)
	meshRotator.set_rotation(startRotation)
	playerShape.set_rotation(Vector3(deg2rad(90), 0, 0))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CameraRotator/SpringArm/Camera.make_current()
	show()
	
func process_input(delta):
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("char_forward"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("char_back"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("char_left"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("char_right"):
		input_movement_vector.y += 1
		
	input_movement_vector = input_movement_vector.normalized()
	
	dir = Vector3()
	dir.z = input_movement_vector.y
	dir.x = input_movement_vector.x
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func process_movement(delta):
	var current_vel = vel
	current_vel.y = vel.y
	current_vel.y -= GRAVITY * delta
	
	dir.y = 0
	var controlRotation = 45
	var controlDir = dir.rotated(Vector3(0, 1, 0), deg2rad(controlRotation))
	
	if dir.length() > 0:
		var dirQuat = Quat(Vector3(0, 1, 0), atan2(-controlDir.z, controlDir.x))
		var meshQuat = Quat(meshRotator.get_global_transform().basis)
		var newRot = meshQuat.slerp(dirQuat, 0.25).get_euler()
		meshRotator.set_rotation(newRot)
		newRot.x = deg2rad(90)
		playerShape.set_rotation(newRot)
	
	var target = Vector3()
	target = controlDir
	
	target *= MAX_SPEED
	target.y = current_vel.y
	
	# For momentum based movement
#	var newDir = meshRotator.get_rotation()
#	var newVec = Vector3(cos(newDir.y), 0, -sin(newDir.y)).normalized()
#	var curr_accel = 0
#	if dir.length() > 0:
#		curr_accel = ACCEL
#	else:
#		curr_accel = DEACCEL
#
#	current_vel = current_vel.linear_interpolate(target, curr_accel * delta)

	# vel = move_and_slide(target, Vector3(0, 1, 0), true, 1, deg2rad(MAX_SLOPE_ANGLE))
	vel = move_and_slide_with_snap(target, Vector3(0, -1, 0), Vector3(0, 1, 0), true, 4, deg2rad(MAX_SLOPE_ANGLE))
	#vel = move_and_slide_with_snap(target, Vector3(0, 1, 0), Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))