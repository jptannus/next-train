extends Control

func _ready() -> void:
  $SlService.updated.connect(_on_trains_updated)
  $SlService.load_departures()

func _on_trains_updated(departures: Array) -> void:
  var trains: Array = $SlService.get_train_departures(departures)
  for train in trains:
    var train_instance = Train.instance_from_train(train)
    $MarginContainer/VBoxContainer.add_child(train_instance)
    train_instance.update()
