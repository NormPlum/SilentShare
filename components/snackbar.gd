extends MarginContainer


#region Signals
signal undo_pressed()
signal timer_expired()
#endregion


#region Virtual Functions
# Timer ends.
func _on_timer_timeout() -> void:
    if is_visible_in_tree():
        hide()
        timer_expired.emit()


# When Undo button is pressed.
func _on_button_pressed() -> void:
    hide()
    undo_pressed.emit()
#endregion


#region Custom Functions
# Display the snackbar.
func display(type: String, item_name: String) -> void:
    # Update the label and show the snackbar.
    %Label.text = "The " + type + " '" + item_name + "' has been deleted."
    show()

    # Start a timer to auto-hide it.
    %Timer.start()
#endregion
