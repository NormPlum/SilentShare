extends PanelContainer


#region Variables
# The user that was just deleted.
var deleted_user: String = ""

# The initial height of the padding node.
var padding_height: int
#endregion


#region Virtual Functions
# Setup the users list.
func _ready() -> void:
    # Store the initial height of the padding node.
    padding_height = %Padding.custom_minimum_size.y

    load_users()


# Adjust canvas layer so it's not covered by the keyboard.
func _process(_delta: float) -> void:
    if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
        %Padding.custom_minimum_size.y = padding_height + (DisplayServer.virtual_keyboard_get_height() / get_window().content_scale_factor)
        %CanvasLayer.offset.y = -(DisplayServer.virtual_keyboard_get_height() / get_window().content_scale_factor)


# When the FAB is pressed.
func _on_fab_button_pressed() -> void:
    add_user()


# When a user is deleted.
func _on_user_deleted(user_name: String) -> void:
    # Store the deleted user.
    deleted_user = user_name

    # Display the snackbar with the user's name.
    %Snackbar.display("user", user_name)


# When a menu is shown.
func _on_menu_shown(node: PanelContainer) -> void:
    for user_node in %VBoxContainer.get_children():
        if user_node.get_class() == "PanelContainer" and user_node.get_node("%Menu").visible and user_node != node:
            user_node.get_node("%Menu").visible = false


# When undo button is pressed.
func _on_snackbar_undo_pressed() -> void:
    # Restore the user.
    add_user(deleted_user)
    deleted_user = ""


# Snackbar's timer expired.
func _on_snackbar_timer_expired() -> void:
    delete_user()


# A child node was added to the VBoxContainer.
func _on_vbox_container_child_entered_tree(_node: Node) -> void:
    # Move the Padding node to the bottom.
    %Padding.move_to_front.call_deferred()


# When changing scene.
func _on_tree_exiting() -> void:
    # Permanently delete the deleted user.
    if deleted_user:
        delete_user()

    # Check if any users are being edited and save them.
    for user_node in %VBoxContainer.get_children():
        if user_node.get_class() == "PanelContainer" and user_node.field_being_edited():
            user_node.save_field()


# Process 'Back' functionality.
func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_GO_BACK_REQUEST:
        get_tree().change_scene_to_file.call_deferred("res://home.tscn")
#endregion


#region Custom Functions
# Load users.
func load_users() -> void:
    for user in Global.users:
        var user_node := preload("res://components/user.tscn").instantiate()
        user_node.user_name = user
        user_node.connect("user_deleted", _on_user_deleted)
        user_node.connect("menu_shown", _on_menu_shown)
        %VBoxContainer.add_child(user_node)


# Add a new user.
func add_user(new_name: String = "") -> void:
    # Instantiate user node and connect its signal.
    var user_node := preload("res://components/user.tscn").instantiate()
    user_node.connect("user_deleted", _on_user_deleted)
    user_node.connect("menu_shown", _on_menu_shown)

    # Add new or existing user.
    if new_name:
        user_node.user_name = new_name
    else:
        user_node.initial_state = "edit"

    # Add the node to the tree.
    %VBoxContainer.add_child(user_node)

    # Hide the snackbar.
    if %Snackbar.is_visible_in_tree():
        %Snackbar.hide()


# Permanently delete the deleted user.
func delete_user() -> void:
    Global.users.erase(deleted_user)
    Global.save_data()
    deleted_user = ""
#endregion
