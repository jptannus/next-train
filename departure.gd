class_name Departure

var destination: String
var direction_code: int
var direction: String
var state: String
var display: String
var scheduled: String
var expected: String
var journey: Dictionary
var stop_area: Dictionary
var stop_point: Dictionary
var line: Dictionary
var deviations: Array

static func new_from_dictionary(dictionary: Dictionary) -> Departure:
  var departure = Departure.new()
  departure.destination = dictionary.destination
  departure.direction_code = dictionary.direction_code
  departure.direction = dictionary.direction
  departure.state = dictionary.state
  departure.display = dictionary.display
  departure.scheduled = dictionary.scheduled
  departure.expected = dictionary.expected
  departure.journey = dictionary.journey
  departure.stop_area = dictionary.stop_area
  departure.stop_point = dictionary.stop_point
  departure.line = dictionary.line
  departure.deviations = dictionary.deviations
  return departure

func is_metro() -> bool:
  return self.line.transport_mode == "METRO"
