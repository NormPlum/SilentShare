extends PanelContainer


#region Variables
var item_name: String
var item_value: String
#endregion


#region Virtual Functions
# Setup view item.
func _ready() -> void:
    %Name.text = item_name
    %Value.text = item_value
#endregion
