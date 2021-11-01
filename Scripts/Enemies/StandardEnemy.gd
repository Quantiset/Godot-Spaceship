extends Enemy
class_name StandardEnemy

var angle := -PI/2



func _physics_process(delta: float) -> void:
	
	var to_player := to_local(player.position)
	
	if to_player.length_squared() > 10000:
		velocity += to_local(player.global_position).normalized() * acceleration
		velocity = velocity.clamped(max_speed)
		$Sprite/SmokeTrail.emitting = true
	else:
		velocity = velocity.linear_interpolate(Vector2(), 0.02)
		$Sprite/SmokeTrail.emitting = false
	
	angle = lerp_angle(angle, velocity.angle(), 0.1)
	
	$Sprite.rotation = angle + PI/2
	$CollisionShape2D.rotation = angle+ PI/2
	
	if randi() % shoot_rate == 1:
		for b_inst in shoot():
			b_inst.rot = velocity.angle()
			b_inst.speed = 10
			b_inst.set_collision_mask_bit(Globals.BIT_PLAYER, true)
			if not b_inst.is_inside_tree():
				get_parent().add_child(b_inst)
		$AudioStreamPlayer2D.play()
	
