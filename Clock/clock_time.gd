class_name ClockTime

var hours: int
var minutes: int
var seconds: int

# Expected format:HH:MM:SS or HH:MM
func set_time(time_info: String) -> void:
  var split: Array = time_info.split(":")
  hours = int(split[0])
  minutes = int(split[1])
  if split.size() == 3:
    seconds = int(split[2])
  else:
    seconds = 0

func _init() -> void:
  var current_time: String = Time.get_time_string_from_system()
  set_time(current_time)
  
func as_string() -> String:
  var result: String = ""
  result += _format_number(hours) + ":"
  result += _format_number(minutes) + ":"
  result += _format_number(seconds)
  return result

func _format_number(n: int) -> String:
  var prefix = ""
  if n < 10:
    prefix = "0"
  return prefix + str(n)
