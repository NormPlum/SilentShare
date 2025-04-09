extends PanelContainer


#region Variables
# The recently-deleted item.
var deleted_item: Dictionary = {}

# The initial height of the padding node.
var padding_height: int
#endregion


#region Virtual Functions
# Setup the edit items screen.
func _ready() -> void:
    # Store the initial height of the padding node.
    padding_height = %Padding.custom_minimum_size.y

    if Global.users[Global.get_current_user()].fields.is_empty():
        add_item()
    else:
        for field in Global.users[Global.get_current_user()].fields:
            # Add items to the tree.
            var item_node := preload("res://components/item_edit.tscn").instantiate()
            item_node.item.name = field
            item_node.item.value = Global.users[Global.get_current_user()].fields[field]
            item_node.connect("item_deleted", _on_item_deleted)
            %VBoxContainer.add_child(item_node)


# Adjust canvas layer so it's not covered by the keyboard.
func _process(_delta: float) -> void:
    if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
        %Padding.custom_minimum_size.y = padding_height + (DisplayServer.virtual_keyboard_get_height() / get_window().content_scale_factor)
        %CanvasLayer.offset.y = -(DisplayServer.virtual_keyboard_get_height() / get_window().content_scale_factor)


# When FAB pressed.
func _on_fab_button_pressed() -> void:
    add_item()


# When item is deleted.
func _on_item_deleted(item) -> void:
    if item.has("name") and item.name:
        # Store the deleted item.
        deleted_item.name = item.name
        deleted_item.value = item.value

        # Display the snackbar with the item's name.
        %Snackbar.display("item", item.name)


# When snackbar's undo button is pressed.
func _on_snackbar_undo_pressed() -> void:
    # Restore the item.
    add_item(deleted_item.name, deleted_item.value)
    deleted_item = {}


# When the snackbar's timer expires.
func _on_snackbar_timer_expired() -> void:
    # Permanently delete the item.
    delete_item()


# A child node was added to the VBoxContainer.
func _on_vbox_container_child_entered_tree(_node: Node) -> void:
    # Move the Padding node to the bottom (to avoid the FAB covering the last item's Delete button).
    %Padding.move_to_front.call_deferred()


# When changing scene.
func _on_tree_exiting() -> void:
    # Permanently delete the deleted item.
    if deleted_item:
        delete_item()

    # Save all items.
    for item_node in %VBoxContainer.get_children():
        if item_node.get_class() == "PanelContainer":
            item_node.save_item()


# Process 'Back' functionality.
func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_GO_BACK_REQUEST:
        get_tree().change_scene_to_file.call_deferred("res://home.tscn")
#endregion


#region Custom Function
# Add an item to the tree.
func add_item(item_name := "", item_value := "") -> void:
    var item_node := preload("res://components/item_edit.tscn").instantiate()
    item_node.item.name = item_name
    item_node.item.value = item_value
    item_node.connect("item_deleted", _on_item_deleted)
    %VBoxContainer.add_child(item_node)


# Permanently delete the deleted item.
func delete_item() -> void:
    Global.users[Global.get_current_user()].fields.erase(deleted_item.name)
    Global.save_data()
    deleted_item = {}
#endregion
