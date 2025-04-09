extends PanelContainer


#region Variables
# The name of the user.
var user_name: String:
    set(value):
        user_name = value
        %UserName.text = value
        %LineEdit.text = value

# The initial state of the user.
var initial_state: String = "view"
#endregion


#region Signals
signal user_deleted(name: String)
signal menu_shown(node: PanelContainer)
#endregion


#region Virtual Functions
# Setup user.
func _ready() -> void:
    # Show the field instead of the label based on the initial state.
    if initial_state == "edit":
        edit_field()


# Main button pressed.
func _on_main_button_pressed() -> void:
    # Set this user as the current one.
    Global.set_current_user(user_name)

    # Change scene back to Home.
    get_tree().change_scene_to_file.call_deferred("res://home.tscn")


# Main button touched (up or down).
func _on_main_button_touched(down: bool) -> void:
    # Update the button styling.
    var stylebox := get_theme_stylebox("panel").duplicate()
    stylebox.draw_center = down
    add_theme_stylebox_override("panel", stylebox)


# Options button pressed.
func _on_options_button_pressed() -> void:
    # Display or hide the options menu.
    if %Menu.is_visible_in_tree():
        %Menu.hide()
    else:
        %Menu.show()
        menu_shown.emit(self)


# Options button tocuhed (up or down).
func _on_options_button_touched(down: bool) -> void:
    # Update the icon colour.
    if down:
        %OptionsButton.self_modulate = Color(Global.COLOURS.ACCENT)
    else:
        %OptionsButton.self_modulate = Color(Global.COLOURS.TEXT_SECONDARY)


# Menu show or hidden.
func _on_menu_visibility_changed() -> void:
    %Menu.global_position = %OptionsButton.global_position + Vector2(%OptionsButton.size.x - %Menu.size.x, %OptionsButton.size.y)
    if %Menu.global_position.y + %Menu.size.y > get_viewport_rect().size.y:
        %Menu.global_position.y = %Menu.global_position.y - %OptionsButton.size.y - %Menu.size.y


# Edit button pressed.
func _on_edit_button_pressed() -> void:
    # Hide the menu and edit the field.
    %Menu.hide()
    edit_field()


# Delete button pressed.
func _on_delete_button_pressed() -> void:
    # Send signal notifying user was deleted.
    user_deleted.emit(user_name)

    # Remove this user.
    queue_free()


# Text edit field submitted.
func _on_line_edit_text_submitted(_new_text: String) -> void:
    save_field()


# Text edit field lost focus.
func _on_line_edit_focus_exited() -> void:
    save_field()
#endregion


#region Custom Functions
# Show field for editing.
func edit_field() -> void:
    %UserName.hide()
    %LineEdit.show()
    %LineEdit.edit()
    %LineEdit.caret_column = %LineEdit.text.length()


# Save the text field.
func save_field() -> void:
    # Ignore if this user is about to be removed.
    if is_queued_for_deletion():
        return

    # Delete user if empty.
    if %LineEdit.text.length() == 0:
        queue_free()
        return

    # Save the new name.
    user_name = %LineEdit.text

    # Update the global users data.
    if not Global.users.has(user_name):
        Global.users.set(user_name, {
            "current": false,
            "fields": {},
        })
        Global.save_data()

    # Switch the text field for the label.
    %LineEdit.hide()
    %UserName.show()


# Check if field is being edited.
func field_being_edited() -> bool:
    return %LineEdit.is_visible_in_tree() and %LineEdit.has_focus()
#endregion
