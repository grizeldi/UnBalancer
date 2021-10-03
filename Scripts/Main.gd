extends Spatial

onready var pieces_node : Spatial = $Level/Pieces;
onready var camera : Camera = $Camera;

var held_piece : Piece;
var upcoming_pieces : Array;
var completion_timer : float = 5;
var dead : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load a level
	var level : Level = Globals.level_to_load.instance()
	$Level.add_child(level)
	upcoming_pieces = level.pieces.duplicate();
	
	next_piece();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!dead):
		# Win conditions
		$UI/BlocksLabel.text = "Blocks left: " + str(len(upcoming_pieces))
		if (len(upcoming_pieces) == 0 && !held_piece):
			completion_timer -= delta;
			$UI/SuccessProgress.value = 5.0 - completion_timer
		if (completion_timer <= 0 && !$UI/Win.visible):
			$UI/Win.visible = true;
		
		if (held_piece):
		# Release the piece
			if (Input.is_action_just_pressed("game_place_block")):
				held_piece.set_mode(RigidBody.MODE_RIGID);
				$Audio/ClickPlayer.play();
				for node in held_piece.get_children():
					if node is CollisionShape:
						node.disabled = false
				next_piece();
			else:
				# Move the piece
				var mouse_pos = get_viewport().get_mouse_position()
				var ray_origin = camera.project_ray_origin(mouse_pos)
				var ray_direction = camera.project_ray_normal(mouse_pos)
				
				var from = ray_origin
				var to = ray_origin + ray_direction * 1000.0
				var space_state = get_world().get_direct_space_state()
				var hit = space_state.intersect_ray(from, to, [], 0b00000000000000000010, false, true);
				held_piece.transform.origin = hit.position;
				
				if (Input.is_action_just_pressed("game_rotate_block_ccw")):
					held_piece.rotate_z(deg2rad(45));
				if (Input.is_action_just_pressed("game_rotate_block_cw")):
					held_piece.rotate_z(deg2rad(-45));

func next_piece():
	if (len(upcoming_pieces) == 0):
		printerr("No pieces left to place");
		held_piece = null;
		return;
	held_piece = upcoming_pieces.pop_front().instance();
	pieces_node.add_child(held_piece);


func _on_piece_fall(body):
	if (!dead):
		dead = true;
		$UI/Lose.visible = true;

func restart():
	get_tree().change_scene("res://Scenes/Game.tscn")


func return_to_level_select():
	get_tree().change_scene("res://Scenes/Main Menu.tscn");
