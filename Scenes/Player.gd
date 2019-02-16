extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var previous_direction = Vector2()
var previous_animation_direction = "down"

func get_input():
    previous_direction = velocity
    velocity.x = 0
    velocity.y = 0
    
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()

    if Input.is_action_pressed('up'):
        velocity.y -= 1
    if Input.is_action_pressed('left'):
        velocity.x -= 1
    if Input.is_action_pressed('right'):
        velocity.x += 1
    if Input.is_action_pressed('down'):
        velocity.y += 1

    return
    
func update_animation():
    if previous_direction.x != velocity.x or previous_direction.y != velocity.y:
        $animation.stop()
        start_animation()
    elif $animation.is_playing():
        pass
    else:
        start_animation()
        
    return

func start_animation():
    assert($animation.is_playing() == false)
    if velocity == Vector2.UP:
        $animation.play("player_walk_up")
        previous_animation_direction = "up"
    elif velocity == Vector2.LEFT or velocity == Constants.UPLEFT or velocity == Constants.DOWNLEFT:
        $animation.play("player_walk_left")
        previous_animation_direction = "left"
    elif velocity == Vector2.RIGHT or velocity == Constants.DOWNRIGHT or velocity == Constants.UPRIGHT:
        $animation.play("player_walk_right")
        previous_animation_direction = "right"
    elif velocity == Vector2.DOWN:
        $animation.play("player_walk_down")
        previous_animation_direction = "down"
    else:
        $animation.play("player_idle_" + previous_animation_direction)
        
    return

func _physics_process(delta):
    get_input()
    update_animation()
    move_and_slide(velocity.normalized() * Constants.ENTITY_BASE_SPEED)
    
    return
