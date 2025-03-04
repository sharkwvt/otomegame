extends Node
class_name Game

@export var customer_scene: PackedScene

var now_level = 1
var show_area
var customers_count = 3
var customers: Array[Customer] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_area = $"表演區"
	set_item()
	$CustomerTimer.start()
	#$CustomerTimer.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_item():
	$"托盤".self_item = data.item.托盤
	$item1.self_item = data.item.道具1
	$item2.self_item = data.item.道具2
	$item3.self_item = data.item.道具3

func create_customer():
	var cs:Customer = customer_scene.instantiate()
	cs.size = Vector2(200, 200)
	cs.position = Vector2(-cs.size.x, (show_area.size.y - cs.size.y)/2.0)
	customers.append(cs)
	show_area.add_child(cs)

func remove_customer(customer: Customer):
	if customer in customers:
		customers.erase(customer)
		customer.queue_free()

func _on_customer_timer_timeout():
	if customers.size() < customers_count:
		create_customer()
	
