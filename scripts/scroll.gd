extends ScrollContainer

@export var delta_for_swipe := Vector2(8, 8)

var look_for_swipe := false
var swiping := false
var swipe_start : Vector2
var swipe_mouse_start : Vector2
var swipe_mouse_times : Array[int] = []
var swipe_mouse_positions : Array[Vector2] = []
var vertical_drag_threshold := 10

func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	if !is_visible_in_tree():
		return

	if event is InputEventScreenDrag and swiping:
		accept_event()
		return

	if event is InputEventMouseButton:

		if event.pressed and get_global_rect().has_point(event.global_position):
			look_for_swipe = true
			swipe_mouse_start = event.global_position

		elif swiping:
			swipe_mouse_times.append(Time.get_ticks_msec())
			swipe_mouse_positions.append(event.global_position)
			var source := Vector2(get_h_scroll(), get_v_scroll())
			var last_swipe_index := swipe_mouse_times.size() - 1
			var now := Time.get_ticks_msec()
			var cutoff := now - 100
			for i in range(swipe_mouse_times.size() - 1, -1, -1):
				if swipe_mouse_times[i] >= cutoff:
					last_swipe_index = i
				else: break
			var flick_start : Vector2 = swipe_mouse_positions[last_swipe_index]
			var flick_duration : float = min(0.3, (event.global_position - flick_start).length() / 1000)
			if flick_duration > 0.0:
				var tween = create_tween()
				var delta : Vector2 = event.global_position - flick_start
				var target := source - delta * flick_duration * 15.0
				var tween_h_property := tween.tween_property(self,'scroll_horizontal', target.x, flick_duration)
				var tween_v_property := tween.parallel().tween_property(self,'scroll_vertical', target.y, flick_duration)
				tween_v_property.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
				tween_h_property.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			swiping = false
			swipe_mouse_times = []
			swipe_mouse_positions = []
		else:
			look_for_swipe = false

	if event is InputEventMouseMotion:
		if swipe_mouse_start.y > event.global_position.y && swipe_mouse_start.y - event.global_position.y < vertical_drag_threshold:
			return

		if swipe_mouse_start.y < event.global_position.y && event.global_position.y - swipe_mouse_start.y < vertical_drag_threshold:
			return

		if swipe_mouse_start.y == event.global_position.y:
			return

		var delta : Vector2 = event.global_position - swipe_mouse_start

		if look_for_swipe && (abs(delta.x) > delta_for_swipe.x or abs(delta.y) > delta_for_swipe.y):
			swiping = true
			look_for_swipe = false
			swipe_start = Vector2(get_h_scroll(), get_v_scroll())
			swipe_mouse_start = event.global_position
			swipe_mouse_times = [Time.get_ticks_msec()]
			swipe_mouse_positions = [swipe_mouse_start]

		if swiping:
			set_h_scroll(int(swipe_start.x - delta.x))
			set_v_scroll(int(swipe_start.y - delta.y))
			swipe_mouse_times.append(Time.get_ticks_msec())
			swipe_mouse_positions.append(event.global_position)
			event.position = Vector2.ZERO
