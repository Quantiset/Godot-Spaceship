extends "res://Scripts/Enemy.gd"

var angle := -PI/2

func _physics_process(delta: float) -> void:
	var to_player := to_local(player.position)
	
	if to_player.length() > 100:
		velocity += to_local(player.position).normalized() * acceleration
		velocity = velocity.clamped(max_speed)
		$Sprite/SmokeTrail.emitting = true
	else:
		velocity = velocity.linear_interpolate(Vector2(), 0.02)
		$Sprite/SmokeTrail.emitting = false
	
	angle = lerp_angle(angle, velocity.angle(), 0.1)
	
	$Sprite.rotation = angle + PI/2
	$CollisionShape2D.rotation = angle+ PI/2
	
	if randi() % shoot_rate == 1:
		var b = preload("res://Scenes/StraightBullet.tscn")
		var b_inst = b.instance()
		b_inst.position = position
		b_inst.rot = velocity.angle()
		b_inst.speed = 10
		b_inst.get_node("CollisionShape2D/RayCast2D").add_exception(self)
		b_inst.set_collision_mask_bit(1, true)
		get_parent().add_child(b_inst)
	
	move_and_slide(velocity, Vector2())
