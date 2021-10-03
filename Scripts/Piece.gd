extends RigidBody

class_name Piece

var overlapping_areas : Array;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_overlap():
	print("Area entered");

func on_exit():
	print("Area exited");
