class_name ClockDate

var year: int
var month: int
var month_day: int
var time: ClockTime

# Expected format: YYYY-MM-DD
func set_date(date_info: String) -> void:
  var split: Array = date_info.split("-")
  year = int(split[0])
  month = int(split[1])
  month_day = int(split[2])

func set_time(time_info: String) -> void:
  time.set_time(time_info)

func set_date_and_time(info: String) -> void:
  var split: Array = info.split("T")
  set_date(split[0])
  set_time(split[1])

func _init() -> void:
  var current_date: String = Time.get_date_string_from_system()
  set_date(current_date)
  time = ClockTime.new()

func as_string() -> String:
  return str(year) + "-" + str(month) + "-" + str(month_day) + "T" + time.as_string()
