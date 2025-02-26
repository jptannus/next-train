extends Control

func _ready() -> void:
  _update_top_margin(_get_window_safe_margin())

func _update_top_margin(value: int) -> void:
  var style_box: StyleBoxTexture = %AppHeaderPanel.get_theme_stylebox("panel")
  style_box.content_margin_top = value - 5
  %AppHeaderPanel.add_theme_stylebox_override("panel", style_box)

func _get_window_safe_margin() -> int:
  var safe_area := DisplayServer.get_display_safe_area()
  return max(safe_area.position.y, 20)
