extends PanelContainer


#region Variables
# This item's name and value.
var item: Dictionary = {
    "name": "",
    "value": "",
}
#endregion


#region Signals
signal item_deleted(item: Dictionary)
#endregion


#region Virtual Functions
# Setup item edit.
func _ready() -> void:
    if item.name:
        %NameEdit.text = item.name
        if item.value:
            %ValueEdit.text = item.value


# When item fields are submitted.
func _on_item_text_submitted(_new_text: String) -> void:
    save_item()


# When item fields lose focus.
func _on_item_focus_exited() -> void:
    save_item()


# Delete button pressed.
func _on_delete_button_pressed() -> void:
    item_deleted.emit(item)
    queue_free()


# Delete button touched (up or down).
func _on_delete_button_touched(down: bool) -> void:
    # Update the icon colour.
    if down:
        %DeleteButton.self_modulate = Color(Global.COLOURS.ACCENT)
    else:
        %DeleteButton.self_modulate = Color(Global.COLOURS.TEXT_SECONDARY)
#endregion


#region Custom Functions
# Save the item.
func save_item() -> void:
    # Ignore if this item is about to be removed.
    if is_queued_for_deletion():
        return

    # Don't save if name is empty.
    if not %NameEdit.text:
        return

    # Save the new item.
    item.name = %NameEdit.text
    item.value = %ValueEdit.text

    # Update the global users data.
    var user = Global.get_current_user()
    var user_fields = Global.users[user].fields
    if item.name not in user_fields or user_fields[item.name] != item.value:
        Global.users[user].fields.set(item.name, item.value)
        Global.save_data()
#endregion
