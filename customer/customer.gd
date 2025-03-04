extends TextureRect
class_name Customer

var root: Game
var ps_bar :ProgressBar

var order = []
var order_timer = 0
var order_time = 20
var order_time_buffer = 0.1 # 訂單緩衝時間比例
var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	create_order()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	order_timer += delta
	ps_bar.value = (order_timer - order_time * order_time_buffer) / order_time
	if order_timer >= order_time * (order_time_buffer + 1):
		timeout()
	
	# 移動到指定點
	if position.distance_to(get_pos()) > 0.1:
		position = position.move_toward(get_pos(), delta * speed)

func setup():
	root = get_node("/root/Root")
	ps_bar = $ProgressBar
	ps_bar.value = 0

func get_pos() -> Vector2:
	var width = size.x + 100
	var index = root.customers.find(self)
	var count = root.customers.size()
	var pos = Vector2(
		(root.show_area.size.x - size.x)/2.0 + (width * ((count-1)/2.0 - index)),
		(root.show_area.size.y - size.y)/2.0
	)
	return pos

func create_order():
	var count = randi_range(1, 3)
	var items = data.get_order_items()
	items.shuffle()
	var item_size = Vector2(50, 50)
	var offset = 10
	$"要求".size = Vector2(item_size.x, (item_size.y + offset) * count)
	$"要求".position.y = self.size.y - $"要求".size.y
	for i in count:
		order.append(items[i])
		var texture_rect := TextureRect.new()
		texture_rect.texture = load(data.item_img_path % data.item_strs[items[i]])
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.size = item_size
		texture_rect.position = Vector2(
			0,
			(item_size.y + offset) * i
		)
		$"要求".add_child(texture_rect)

func send_order(items: Array):
	if items.size() != order.size():
		wrong_order()
		return
	
	for item in items:
		if item not in order:
			wrong_order()
			return
	
	correct_order()

func wrong_order():
	print("送錯")
	root.remove_customer(self)

func correct_order():
	print("送對")
	root.remove_customer(self)

func timeout():
	print("超時")
	root.remove_customer(self)

# 有東西放上來時
func _drop_data(_at_position: Vector2, drag_item: Variant) -> void:
	if drag_item != self and drag_item is Tray:
		var tray: Tray = drag_item
		send_order(tray.items)
		tray.reset_items()
# 投放判定
func _can_drop_data(_at_position: Vector2, item: Variant) -> bool:
	return item is Tray
