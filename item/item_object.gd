extends ColorRect
class_name ItemObject

var self_item
var self_img: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_img = get_node("TextureRect")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _get_drag_data(_at_position: Vector2) -> Variant:
	var node := Control.new()
	var texture_rect := TextureRect.new()
	texture_rect.texture = load(data.item_img_path % data.item_strs[self_item])
	texture_rect.size = Vector2(100, 100)
	texture_rect.position = Vector2(-texture_rect.size.x/2.0, -texture_rect.size.y/2.0)
	node.add_child(texture_rect)
	set_drag_preview(node)
	return self
