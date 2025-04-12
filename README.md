# Godot Github Issues Integration
This plugin adds a new dock to your godot editor that allows you
to view (and soon edit) github issues right inside of the godot editor.

## Current Limitations
- Currently only works on public repositories.
- Cannot edit or close issues from editor.
- Must add your respository details directly in the source code.
- Cannot properly filter issues

## Screenshot
![image](https://github.com/user-attachments/assets/aeab6c2c-32a5-4574-96dc-668acb593203)

### Goals
1. Github OAuth to allow for private repos and editing of issues
2. Add filter functionality to allow you to filter by tag, title, description, and assignees.
3. (maybe) pull request creator and editor.

### Special Thanks
To EiTaNBaRiBoA for providing the JsonClassConverter used to serialize/deserialize the JSON objects returned from Github's REST api.
