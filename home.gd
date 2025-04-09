extends PanelContainer


#region Variables
# An array of items that are ticked.
var ticked_items: Array = []
#endregion


#region Virtual Functions
# Setup the home screen.
func _ready() -> void:
    # Set the scale factor based on the screen scale.
    get_window().content_scale_factor = DisplayServer.screen_get_scale()

    # Display the current user's data.
    load_current_user()


# Adjust canvas layer so it's not covered by the keyboard.
func _process(_delta: float) -> void:
    if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
        %CanvasLayer.offset.y = -(DisplayServer.virtual_keyboard_get_height() / get_window().content_scale_factor)


# When a checkbox is ticked/unticked.
func _on_item_checkbox_toggled(toggled_on: bool, item_name: String, item_value: String) -> void:
    var item := {
        "name": item_name,
        "value": item_value,
    }

    # Keep a list of which items are ticked.
    if toggled_on:
        ticked_items.append(item)
    else:
        ticked_items.erase(item)

    # Update the FAB based on the number of checkboxes ticked.
    if ticked_items.size() > 0:
        %FAB.update_button({
            "texture_normal": preload("res://resources/icons/visibility.png"),
            "texture_hover": preload("res://resources/icons/visibility_fill.png"),
            "tooltip_text": "View items",
        })
    else:
        %FAB.update_button({
            "texture_normal": %FAB.button_texture_normal,
            "texture_hover": %FAB.button_texture_hover,
            "tooltip_text": %FAB.button_tooltip,
        })


# When the FAB is pressed.
func _on_fab_button_pressed() -> void:
    if ticked_items.size() > 0:
        # Change scenes manually so we can pass through the ticked items.
        var view_items_node = preload("res://view_items.tscn").instantiate()
        view_items_node.items = ticked_items
        get_tree().root.add_child(view_items_node)
        get_tree().current_scene = view_items_node
        get_node("/root/Home").free.call_deferred()
    else:
        # Edit items.
        get_tree().change_scene_to_file.call_deferred("res://edit_items.tscn")


# Process 'Back' functionality.
func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_GO_BACK_REQUEST:
        get_tree().quit()
#endregion


#region Custom Functions
# Load the current user.
func load_current_user() -> void:
    var user := Global.get_current_user()

    # Set the app bar headline.
    %AppBar.headline = user

    # Load the fields.
    for item in Global.users[user].fields:
        var item_node = preload("res://components/item_view.tscn").instantiate()
        item_node.item_name = item
        item_node.item_value = Global.users[user].fields[item]
        item_node.connect("checkbox_toggled", _on_item_checkbox_toggled)
        %VBoxContainer.add_child(item_node)
#endregion
