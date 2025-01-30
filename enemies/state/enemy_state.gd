class_name EnemyState extends Node

var state_machine: EnemyStateMachine = null


# Called when entering this state
func enter() -> void:
	pass


# Called when exiting this state
func exit() -> void:
	pass


# Updates state physics behavior
func physics_update(_delta: float) -> void:
	pass


# Handles input events for this state
func handle_input(_event: InputEvent) -> void:
	pass
