extends Node2D
class_name SLService

signal updated(departures: Array)

const STATION_ID = 9103
const TRANSPORT = "METRO"
const DIRECTION = 2
const FORECAST = 30
const DEPARTURES_URL = "https://transport.integration.sl.se/v1/sites/${STATION_ID}/departures"

var _loaded_departures: Array;

func load_departures() -> void:
  $HTTPRequest.request_completed.connect(_on_request_completed)
  var url: String = DEPARTURES_URL.replace("${STATION_ID}", str(STATION_ID))
  url += "?" + build_query_params(TRANSPORT, DIRECTION, FORECAST)
  $HTTPRequest.request(url)

@warning_ignore("unused_parameter")
func _on_request_completed(result, response_code, headers, body):
  var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
  var departures: Array = _convert_to_departures(json.departures)
  _loaded_departures = departures
  updated.emit(departures)
    
func _convert_to_departures(data: Array) -> Array:
  var departures: Array = []
  for raw_departure: Dictionary in data:
    var departure = Departure.new_from_dictionary(raw_departure)
    departures.push_back(departure)
  return departures

func get_train_departures(departures: Array) -> Array:
  var trains: Array = [] 
  var train_departures = departures.filter(func(dep: Departure): return dep.is_metro())
  for departure in train_departures:
    var train: Train = Train.new_from_departure(departure)
    trains.push_back(train)
  return trains

func get_cached_departures() -> Array:
  return _loaded_departures

func build_query_params(transport: String, direction: int, forecast: int) -> String:
  return "transport=" + transport + "&direction=" + str(direction) + "&forecast=" + str(forecast)
