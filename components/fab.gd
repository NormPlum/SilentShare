extends MarginContainer


#region Variables
# The button's normal icon.
@export var button_texture_normal: Texture2D

# The button's hover icon.
@export var button_texture_hover: Texture2D

# The button's tooltip text.
@export var button_tooltip: String
#endregion


#region Signals
signal button_pressed()
#endregion


#region Virtual Functions
# Setup FAB.
func _ready() -> void:
    # Set the initial textures and tooltip.
    %TextureButton.texture_normal = button_texture_normal
    %TextureButton.texture_hover = button_texture_hover
    %TextureButton.tooltip_text = button_tooltip


# Button pressed.
func _on_texture_button_pressed() -> void:
    button_pressed.emit()


# Button touched (up or down).
func _on_texture_button_touched(down: bool) -> void:
    # Change the button colour.
    if down:
        %PanelContainer.self_modulate = Color(Global.COLOURS.DARKER)
    else:
        %PanelContainer.self_modulate = Color(Global.COLOURS.ICONS)
#endregion


#region Custom Functions
# Update button.
func update_button(properties: Dictionary) -> void:
    # Set new properties on the button.
    for property in properties:
        %TextureButton.set(property, properties[property])
#endregion
