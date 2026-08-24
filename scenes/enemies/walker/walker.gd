class_name Walker
extends Enemy

@onready var wall_check: RayCast2D = $AnimatedSprite2D/WallCheck
@onready var ground_check: RayCast2D = $AnimatedSprite2D/GroundCheck
@onready var hitbox_shape: CollisionShape2D = $AnimatedSprite2D/Hitbox/CollisionShape2D
