extends KinematicBody2D

var movement_speed = 250
var number_of_bombs = 5
var waited = 0
var bomb_delay = 0.2
var distance = 64
var max_tiles = 5


var vel = Vector2()
var position_translated = Vector2()

var bomb_placement = []
var tile_checker = []
var final_tile_checker = []

var bomb_placed = false

onready var sprite: Sprite = get_node("Sprite")

var Explosion = load("res://Explosion.tscn")
onready var solid_tiles = get_node("/root/MainScene/YSort/Solid_Block_Tile")
onready var explodable_tiles = get_node("/root/MainScene/YSort/Explodable_Block_Tile")





func _process(_delta):
	""" Player Movement """
	vel.x = 0
	vel.y = 0
	
	if Input.is_action_pressed("move_left"):
		vel.x -= movement_speed
		
	elif Input.is_action_pressed("move_right"):
		vel.x += movement_speed
		
	elif Input.is_action_pressed("move_up"):
		vel.y -= movement_speed
		
	elif Input.is_action_pressed("move_down"):
		vel.y += movement_speed
	
	vel = move_and_slide(vel, Vector2.UP)
	
	
	# Under is the code for instantiating the bomb 
	if Input.is_action_just_pressed("place_bomb") and number_of_bombs > 0:
		place_bomb()
#		print(bomb_placed)
		
		
func place_bomb():
	""" This is for instantiating the bomb and have it set postion to fit a 64x64 Tile. """
	
	var Bomb = load("res://Bomb.tscn")
	var bomb = Bomb.instance()
	var world = get_tree().current_scene
	bomb.position = Vector2(64 * round(global_position.x/64), 64 * round(global_position.y/64)) #fixing position

	
	#spawning the bomb  
	if !(bomb.position in bomb_placement):
		world.add_child(bomb)
		bomb_placement.append(Vector2(bomb.position.x, bomb.position.y)) #adding vectors to an array
#		print("Bomb Placed")
		number_of_bombs -= 1
		bomb_timer(bomb)
		
	else:
		print("Bomb Not Placed")
		
#	print(bomb.position + Vector2(32,32))
	
	bomb_placed = false
	
		
		
func bomb_timer(bomb_instance):
	""" Yield method with timer, when timer goes it destroys bomb instance"""

	
	yield(get_tree().create_timer(3.0), "timeout")
	check_tile(bomb_instance)
	bomb_instance.visible = false
	
	
	yield(get_tree().create_timer(.5), "timeout")
	bomb_placement.pop_front()
	number_of_bombs += 1
	
	bomb_instance.queue_free()


func check_tile(bomb_instance):

	var Destroy_block = false

	
	var current_tile = Vector2()
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

	for direction in directions:
		current_tile = Vector2(bomb_instance.position.x + 32, bomb_instance.position.y + 32)
		tile_checker.append(current_tile)
		Destroy_block = false
		
		for tile in max_tiles:
			current_tile = current_tile + (distance * direction)
			
			print(bomb_placement)
			print(current_tile)
			
			if Destroy_block == true:
				break	
			
			elif not current_tile in solid_tiles.final_list_of_tile_positions:
				if current_tile in explodable_tiles.final_list_of_tile_positions:
					
					remove_block(current_tile)
					tile_checker.append(current_tile)
					Destroy_block = true
					
				elif (current_tile + Vector2(32,32)) in bomb_placement:
					tile_checker.append(current_tile)
					check_tile(bomb_instance)
					
					print(true)
					Destroy_block = true
					
				else:
					tile_checker.append(current_tile)
				
			else:
				break
				
	for positions in tile_checker:
		if not positions in final_tile_checker:
			final_tile_checker.append(positions)
		
	for positions in final_tile_checker:
		make_explosion(positions)
		
	
	final_tile_checker.clear()
	tile_checker.clear()
	

func make_explosion(positions):
	var explosion = Explosion.instance()

	explosion.position = positions
	get_tree().current_scene.add_child(explosion, true)
	
	yield(get_tree().create_timer(.5), "timeout")
	explosion.queue_free()

func remove_block(current_position):
	
	position_translated = explodable_tiles.world_to_map(current_position)
	
	explodable_tiles.set_cellv(position_translated, -1) # This needs to take in a world to map input to work
#	print(current_position)
	var i = explodable_tiles.final_list_of_tile_positions.find(current_position)
#	print(i)
	explodable_tiles.final_list_of_tile_positions.remove(i)
#	print(explodable_tiles.final_list_of_tile_positions)
	
	
#	Now I just need to find how to chainlink the bombs together so that when goes off and the explosion is in contact it will
#	set off the next one. 
#	
	
	
#	while distance < max_distance:
#
#		current_tile = bomb_instance.position
##		current_tile = current_tile + (distance * direction)
#
#		if (!current_tile in solid_tiles.list_of_tile_positions):
#			tile_checker.append(current_tile)
#			print(tile_checker)
#			distance += 64
#		else:
#			break
#
#	for i in range(0,len(tile_checker)):
#		explosion.global_position = tile_checker[i] + Vector2(32,32)
#		add_child(explosion)
#		print(explosion.position)
#
#	yield(get_tree().create_timer(.5), "timeout")
#
#	explosion.queue_free()
