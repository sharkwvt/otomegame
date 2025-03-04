extends ItemObject
class_name Tray

var items = []

func add_item(item: ItemObject):
	if item.self_item not in items:
		items.append(item.self_item)
	refresh_items()

func reset_items():
	items = []
	refresh_items()

func refresh_items():
	# 刪除全部
	for node in self_img.get_children():
		node.queue_free()
	
	create_items(self_img)

# 創建物件
func create_items(node: Node):
	var offset = 10
	for i in items.size():
		var texture_rect := TextureRect.new()
		texture_rect.texture = load(data.item_img_path % data.item_strs[items[i]])
		texture_rect.size = Vector2(100, 100)
		texture_rect.position = Vector2(
			(node.size.x - texture_rect.size.x)/2.0 + (i - (items.size()-1)/2.0) * (texture_rect.size.x + offset),
			(node.size.y - texture_rect.size.y)/2.0
		)
		node.add_child(texture_rect)

# 覆寫拖曳
func _get_drag_data(_at_position: Vector2) -> Variant:
	self_img.visible = false
	
	var node := Control.new()
	var texture_rect := TextureRect.new()
	texture_rect.texture = load(data.item_img_path % data.item_strs[self_item])
	texture_rect.size = Vector2(100, 100)
	texture_rect.position = Vector2(-texture_rect.size.x/2.0, -texture_rect.size.y/2.0)
	node.add_child(texture_rect)
	create_items(texture_rect)
	set_drag_preview(node)
	return self

# 有東西放上來時
func _drop_data(_at_position: Vector2, drag_item: Variant) -> void:
	if drag_item != self and drag_item is ItemObject:
		add_item(drag_item)
# 投放判定
func _can_drop_data(_at_position: Vector2, item: Variant) -> bool:
	return item is ItemObject

func _notification(what:int)->void:
	# 沒有拖曳取消的事件，直接全域偵測
	if what == NOTIFICATION_DRAG_END and self_item == data.item.托盤:
		self_img.visible = true
