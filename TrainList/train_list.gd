extends Control

const REFRESH_INTERVAL = 10

func _ready() -> void:
  $SlService.updated.connect(_on_trains_updated)
  %Timer.timeout.connect(_on_timer_timeout)
  _reload_departures()

func _on_trains_updated(departures: Array) -> void:
  var trains: Array = $SlService.get_train_departures(departures)
  for train in trains:
    var train_instance = Train.instance_from_train(train)
    $MarginContainer/VBoxContainer.add_child(train_instance)
    train_instance.update()

func _clear_list() -> void:
  for child in $MarginContainer/VBoxContainer.get_children():
    child.queue_free()

func _reload_departures() -> void:
  _clear_list()
  $SlService.load_departures()
  await $SlService.updated
  %Timer.start(REFRESH_INTERVAL)

func _on_timer_timeout() -> void:
  _reload_departures()
