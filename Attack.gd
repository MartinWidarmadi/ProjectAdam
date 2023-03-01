extends Node2D

onready var timer = $Timer

func start_attack(dur, input):
	var check_attack = is_attacking()
	
	
func is_attacking():
	return !timer.is_stopped()
