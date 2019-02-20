extends KinematicBody2D

var Generic_Bullet = preload("res://Scenes/Generic_Bullet.tscn")

var velocity = Vector2()
var previous_direction = Vector2()
var previous_animation_direction = "down"
var do_shoot
var mouse_position = Vector2()
const BULLET_MAX = 10

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
        
    if Input.is_mouse_button_pressed(BUTTON_LEFT):
        if $bullet_cooldown.is_stopped():
            do_shoot = true
            

func update_animation():
    if previous_direction.x != velocity.x or previous_direction.y != velocity.y:
        $animation.stop()
        start_animation()
    
        
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


func shoot():
    if do_shoot == true:
        var parent = get_parent()
        var bullet = Generic_Bullet.instance()
        bullet.position = position
        parent.add_child(bullet)
        $bullet_cooldown.start()
    do_shoot = false
    

func _process(delta):
    get_input()
    update_animation()
    shoot()


func _physics_process(delta):
    move_and_slide(velocity.normalized() * Constants.ENTITY_BASE_SPEED)

