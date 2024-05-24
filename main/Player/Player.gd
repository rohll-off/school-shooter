extends CharacterBody2D

const SPEED = 250.0
const bullet_speed = 1500.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Fetching/loading the bullet scene
var bullet = preload("res://Player/Bullet.tscn")
@onready var player = get_node("AnimatedSprite2D")

func _ready():
	player.play("Run")

func _process(_delta):
	# shooting
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = player.global_position
		bullet_instance.add_central_impulse(Vector2(bullet_speed, 0))
		get_tree().root.add_child(bullet_instance)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta) # Adjusted to use delta

	# Move and slide with the calculated velocity
	move_and_slide()
