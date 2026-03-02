extends PanelContainer


#region Variables
# The name of the item.
var item_name: String

# The value of the item.
var item_value: String
#endregion


#region Signals
signal checkbox_toggled(toggled_on: bool, item_name: String, item_value: String)
#endregion


#region Virtual Functions
# Setup item view.
func _ready() -> void:
    %Name.text = item_name
    %Value.text = item_value


# When the checkbox is ticked/unticked.
func _on_check_box_toggled(toggled_on: bool) -> void:
    # Change the icon colour.
    if toggled_on:
        %CheckBox.self_modulate = Color(Global.COLOURS.ACCENT)
    else:
        %CheckBox.self_modulate = Color(Global.COLOURS.TEXT_SECONDARY)

    # Emit a signal.
    checkbox_toggled.emit(toggled_on, item_name, item_value)


# When the item is clicked.
func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
        # Ignore presses/clicks on the checkbox itself, as they're already covered by _on_check_box_toggled().
        if get_global_rect().has_point(event.global_position) and \
                not %CheckBox.get_global_rect().has_point(event.global_position):
            %CheckBox.button_pressed = !%CheckBox.button_pressed
#endregion
