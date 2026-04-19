class_name FoodItem
extends FloatingBody3D

enum FoodType {
	NONE,
	APPLE,
	ONION,
	POTATO,
	BOMB
}

@onready var interactible_component: InteractibleComponent = %InteractibleComponent

@export var food_type := FoodType.NONE
