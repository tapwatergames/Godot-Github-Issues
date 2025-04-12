@tool
class_name MainVBox
extends VBoxContainer

func _ready() -> void:
  %Refresh.pressed.connect(on_refresh_pressed)
  
func on_refresh_pressed() -> void:
  GithubIssues.instance.fetch_issues()
