extends PanelContainer


#region Variables
# The list of items to show.
var items: Array
#endregion


#region Virtual Functions
# Setup view items.
func _ready() -> void:
    for item in items:
        var item_node := preload("res://components/view_item.tscn").instantiate()
        item_node.item_name = item.name
        item_node.item_value = item.value
        %VBoxContainer.add_child(item_node)


# Process 'Back' functionality.
func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_GO_BACK_REQUEST:
        get_tree().change_scene_to_file.call_deferred("res://home.tscn")
#endregion
