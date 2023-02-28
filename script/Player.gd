extends KinematicBody2D


# Declare member variables here. Examples:
var normal_speed = 200.0
var dash_speed = 800.0
var dash_length = .1
var velocity = Vector2.ZERO
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get('parameters/playback')
onready var player = $Sprite
onready var dash = $dash

func animation_and_movement():
	var current = playback.get_current_node()
	var speed = dash_speed if dash.is_dashing() else normal_speed
	velocity = Vector2.ZERO
	
#		if Input.is_action_just_pressed("attack"):
#			playback.travel("sword-combo-2")
#			if Input.is_action_just_pressed("attack"):
#				playback.travel("sword-combo-3")
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
	if velocity.length() == 0:
		playback.travel("idle")
	if velocity.length() > 0:
		playback.travel("run")
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(dash_length)
			playback.travel("dash")
		if Input.is_action_just_pressed("attack"):
			playback.travel("sword-combo-1")
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	animation_and_movement()
	velocity = move_and_slide(velocity)
	
	
