extends KinematicBody2D

const GRAV = 20
export var JUMP_POWER = 500
export var speed = 500
export var max_jumps = 2
var motion = Vector2(0, 0)
var UP = Vector2(0,-1)
var consecutive_jumps = 0
export var speed_mult = 1.0
var jump_buffer = 0
var in_air = true
var max_jump_buffered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func suppress_max_jumps():
	jump_buffer = max_jumps
	max_jumps = 1
	max_jump_buffered = true
	#print("max jumps" + String(max_jumps) + String(jump_buffer))
func restore_max_jumps():
	if max_jump_buffered:
		max_jumps = jump_buffer
		max_jump_buffered = false

func get_motion():
	return motion
func set_speed_mult(new_speed_mult):
	speed_mult = new_speed_mult

func is_player():
	pass
	
func is_moving_down():
	if motion.y > 0:
		return true
	else:
		return false

func get_speed_mult():
	return speed_mult
	
func set_speed(new_speed):
	speed = new_speed

func get_speed():
	return speed

#Checks for certain input events and executes code accordingly
func check_and_exec():
	print(is_jumpable())
	print(consecutive_jumps)
	# Jumping Mechanics
	if Input.is_action_just_pressed("ui_up") and is_jumpable():
		
		motion.y = -JUMP_POWER
		consecutive_jumps += 1
		set_safe_margin(0.001)
		in_air = 1
		set_safe_margin(0.002)
		

	
	# Lateral Motion
	if Input.is_action_pressed("ui_left"):
		motion.x = -speed * speed_mult
	elif Input.is_action_pressed("ui_right"):
		motion.x = speed * speed_mult
	else:
		motion.x = 0

func is_jumpable():
	if consecutive_jumps < max_jumps:
		print("JUMP")
		return true
	else:
		return false

func reset_jumps(jumpnum = 0):
	consecutive_jumps = jumpnum

func process_state():
	if is_on_floor() and in_air:
		reset_jumps()

func ambient_physical():
	#Gravity Processing
	motion.y += GRAV
func _physics_process(delta):
	#print(consecutive_jumps)
	check_and_exec()
	process_state()
	ambient_physical()
	motion = move_and_slide(motion, UP)

