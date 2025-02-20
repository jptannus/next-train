extends Node2D
class_name SLService

signal updated(departures: Array)

const STATION_ID = 9103
const PREVIOUS_STATION_ID = 9102
const TRANSPORT = "METRO"
const DIRECTION = 2
const FORECAST = 30
const DEPARTURES_URL = "https://transport.integration.sl.se/v1/sites/${STATION_ID}/departures"

var _loaded_departures: Dictionary;
var _request_station: int

func _ready() -> void:
  $HTTPRequest.request_completed.connect(_on_request_completed)

func load_departures() -> void:
  _load_from_station(STATION_ID)
  await $HTTPRequest.request_completed
  _load_from_station(PREVIOUS_STATION_ID)
  await $HTTPRequest.request_completed
  var departures: Array = _calculate_empty_seats()
  updated.emit(departures)

func _load_from_station(station_id: int) -> void:
  _request_station = station_id
  var url: String = DEPARTURES_URL.replace("${STATION_ID}", str(station_id))
  url += "?" + build_query_params(TRANSPORT, DIRECTION, FORECAST)
  $HTTPRequest.request(url)

@warning_ignore("unused_parameter")
func _on_request_completed(result, response_code, headers, body):
  var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
  var departures: Array = _convert_to_departures(json.departures)
  _loaded_departures[_request_station] = departures
    
func _convert_to_departures(data: Array) -> Array:
  var departures: Array = []
  for raw_departure: Dictionary in data:
    var departure = Departure.new_from_dictionary(raw_departure)
    departures.push_back(departure)
  return departures

func _calculate_empty_seats() -> Array:
  for d1: Departure in _loaded_departures[STATION_ID]:
    d1.empty_seats = true
    for d2: Departure in _loaded_departures[PREVIOUS_STATION_ID]:
      if _same_departure(d1, d2):
        d1.empty_seats = false
  return _loaded_departures[STATION_ID]

func _same_departure(d1: Departure, d2: Departure) -> bool:
  if d1.destination != d2.destination:
    return false
  var time_diff = Clock.time_between_dates(Clock.new_date(d1.expected), Clock.new_date(d2.expected))
  if time_diff.hours > 0 or time_diff.minutes > 4:
    return false
  return true

func get_train_departures(departures: Array) -> Array:
  var trains: Array = [] 
  var train_departures = departures.filter(func(dep: Departure): return dep.is_metro())
  for departure in train_departures:
    var train: Train = Train.new_from_departure(departure)
    trains.push_back(train)
  return trains

func get_cached_departures(station_id: int) -> Array:
  return _loaded_departures[station_id]

func build_query_params(transport: String, direction: int, forecast: int) -> String:
  return "transport=" + transport + "&direction=" + str(direction) + "&forecast=" + str(forecast)
