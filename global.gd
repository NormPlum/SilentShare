extends Node


#region Constants
# Colour scheme.
# From: https://www.materialpalette.com/blue-grey/orange
const COLOURS := {
    "PRIMARY_DARK": "455a64",
    "PRIMARY_LIGHT": "cfd8dc",
    "PRIMARY": "607d8b",
    "ICONS": "ffffff",
    "ACCENT": "ff9800",
    "TEXT_PRIMARY": "212121",
    "TEXT_SECONDARY": "757575",
    "DIVIDER": "bdbdbd",
    "DARKER": "e6e6e6",
}

# Directory for saving/loading data.
const SAVE_FILE: String = "user://users.data"
#endregion


#region Variables
# User data.
var users: Dictionary = {}
#endregion


#region Virtual Functions
# Setup app.
func _ready() -> void:
    load_data()
    if users.is_empty():
        users = {
            "Me": {
                "current": true,
                "fields": {
                    "Name": "My name",
                    "Phone": "0000 123 456",
                },
            },
        }
#endregion


#region Custom Functions
# Load data from file.
func load_data() -> void:
    if FileAccess.file_exists(SAVE_FILE):
        var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
        users = file.get_var()
        file.close()


# Save data to file.
func save_data() -> void:
    var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
    file.store_var(users)
    file.close()


# Get current user.
func get_current_user() -> String:
    for user in users:
        if users[user].current:
            return user

    # If no user is set as 'current', return the first user.
    var user = users.keys()[0]
    users[user].current = true
    return user


# Set user as current.
func set_current_user(user_name: String) -> void:
    for user in users:
        users[user].current = false
    users[user_name].current = true
    save_data()
#endregion
