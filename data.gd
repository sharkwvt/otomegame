extends Node
class_name Data

var item_img_path = "res://item/%s.png"
var item_strs = ["item1", "item2", "item3", "托盤"]

enum item {
	道具1,
	道具2,
	道具3,
	托盤
}

var now_level = 1

func get_enabled_items() -> Array:
	var items = []
	for i in data.item_strs.size()-1:
		items.append(i)
	return items
