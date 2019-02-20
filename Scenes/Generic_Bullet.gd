extends Area2D

var origin
var target
const BULLET_SPEED = 1000
# signal hit(body, damage)

func _ready():
    look_at(get_viewport().get_mouse_position())
    target = get_viewport().get_mouse_position() - position
    origin = position
    
func free():
    queue_free()

func _physics_process(delta):
    global_translate(target.normalized() * BULLET_SPEED * delta)
    if origin.distance_to(position) > Constants.PROJECTILE_MAX_DISTANCE:
        free()