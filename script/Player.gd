extends KinematicBody2D


# Declare member variables here. Examples:
var normal_speed = 200.0
var dash_speed = 800.0
var attack_move_speed = 8.0
var dash_length = .1
var velocity = Vector2.ZERO
onready var is_not_attacking = true
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get('parameters/playback')
onready var player = $Sprite
onready var dash = $dash
onready var timer = $Timer
var animation_name = ["sword1", "sword2", "sword3"]
var animation_idx = 0

func attack_mechanic():
	# If attack button clicked
	if Input.is_action_just_pressed("attack"):
		is_not_attacking = false
		# Move the player with attacking
		if player.flip_h == false:
			velocity.x += 1
		else:
			velocity.x -= 1
		velocity = velocity.normalized() * attack_move_speed
		# Check if animation frame is over
		if animation_idx == animation_name.size():
			animation_idx = 0
		# Start timer and play the attack animation
		timer.start()
		playback.travel(animation_name[animation_idx])
		# Check if user clicked the button before attack duration are over
		# If not, change the next animation
		if timer.time_left > 0:
			animation_idx += 1
		# If it's over but the user didn't click the button, restart the animation
		else:
			animation_idx = 0

		
	

func player_movement():
	var current = playback.get_current_node()
	var speed = dash_speed if dash.is_dashing() else normal_speed
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("down"):
		velocity.y += 1.0
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
	if Input.is_action_pressed("right"):
		velocity.x += 1.0
		player.flip_h = false
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		player.flip_h = true
	velocity = velocity.normalized() * speed
	
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else:
		playback.travel("run")
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(dash_length)
			playback.travel("dash")	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if is_not_attacking:
		player_movement()
	attack_mechanic()

	velocity = move_and_slide(velocity)
	
	


func _on_Timer_timeout():
	is_not_attacking = true
