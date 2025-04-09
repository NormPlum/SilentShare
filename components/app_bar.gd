extends PanelContainer


#region Constants
# A list of types this app bar can be.
enum TYPES {
    PRIMARY,
    SECONDARY,
}
#endregion


#region Variables
# The type of app bar this is.
@export var type: TYPES = TYPES.SECONDARY

# The text to show in the app bar.
@export var headline: String:
    set(value):
        headline = value
        %Label.text = value
#endregion


#region Virtual Functions
# Setup app bar.
func _ready() -> void:
    # Configure primary layout if necessary.
    if type == TYPES.PRIMARY:
        %BackButton.visible = false
        %Label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        %UserButton.visible = true


# Back button pressed.
func _on_back_button_pressed() -> void:
    # Load the Home scene.
    get_tree().change_scene_to_file.call_deferred("res://home.tscn")


# User button pressed.
func _on_user_button_pressed() -> void:
    # Load the Users scene.
    get_tree().change_scene_to_file.call_deferred("res://users.tscn")


# Button touched (up or down).
func _on_button_touched(button: String, down: bool) -> void:
    if down:
        get_node("%" + button).self_modulate = Color(Global.COLOURS.ACCENT)
    else:
        get_node("%" + button).self_modulate = Color(Global.COLOURS.ICONS)
#endregion
