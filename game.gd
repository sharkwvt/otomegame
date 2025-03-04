extends Node
class_name Game

@export var customer_scene: PackedScene

var show_area: Control
var customers_count = 3
var customers: Array[Customer] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	$CustomerTimer.start()
	$"回合數".text = "回合 " + str(data.now_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$"倒數".text = str(int($GameTimer.time_left))

func setup():
	show_area = $"表演區"
	$"托盤".self_item = data.item.托盤
	$item1.self_item = data.item.道具1
	$item2.self_item = data.item.道具2
	$item3.self_item = data.item.道具3

func create_customer():
	var cs:Customer = customer_scene.instantiate()
	cs.size = Vector2(200, 200)
	cs.position = Vector2(-cs.size.x, (show_area.size.y - cs.size.y)/2.0)
	cs.root = self
	customers.append(cs)
	show_area.add_child(cs)

func remove_customer(customer: Customer):
	if customer in customers:
		customers.erase(customer)

func gameover():
	print("遊戲結束")

func _on_customer_timer_timeout():
	if customers.size() < customers_count:
		create_customer()

func _on_game_timer_timeout() -> void:
	print("時間到")
	gameover()
