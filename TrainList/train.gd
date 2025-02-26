extends MarginContainer
class_name Train

var destination: String
var departure_time: ClockDate
var empty_train: bool

func update() -> void:
  $"%Destination".text = destination
  if empty_train:
    $"%Destination".text += "****"
  $"%DepartureTime".text = "(" + departure_time.time.as_string().left(5) + ")"
  
  var time_to_leave_text = ""
  var time_to_leave = Clock.time_from_now(departure_time)
  if time_to_leave.hours == 0 and time_to_leave.minutes == 0:
    time_to_leave_text = "Nu"
  elif time_to_leave.hours == 0:
    time_to_leave_text = str(time_to_leave.minutes) + " min"
  else:
    time_to_leave_text = str(time_to_leave.hours) + " hour"
    if time_to_leave.hours > 1:
      time_to_leave_text += "s"
    time_to_leave_text += " " + str(time_to_leave.minutes) + " min"
  $"%TimeToLeave".text = time_to_leave_text

static func new_from_departure(departure: Departure) -> Train:
  var train: Train = Train.new()
  train.destination = departure.destination
  train.departure_time = Clock.new_date(departure.expected)
  train.empty_train = departure.empty_seats
  return train

static func print(train: Train) -> void:
  print("{ destination: " + train.destination + ", departure_time: " + train.departure_time.as_string() + ", empty_train: " + str(train.empty_train) + "}")

static func instance_from_train(train: Train) -> Object:
  var train_scene: Object = load("res://TrainList/Train.tscn")
  var train_instance: Object = train_scene.instantiate()
  train_instance.destination = train.destination
  train_instance.departure_time = train.departure_time
  train_instance.empty_train = train.empty_train
  return train_instance;
