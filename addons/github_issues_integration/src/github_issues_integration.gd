@tool
class_name GithubIssues
extends EditorPlugin

var dock
static var instance : GithubIssues

var issue_list : Array[Issue]

signal issue_list_set(issue_list : Array[Issue])

var user : String
var repository : String

func _enter_tree() -> void:
  instance = self
  # Initialization of the plugin goes here.
  dock = preload("res://addons/github_issues_integration/Scene/dock.tscn")
  dock = dock.instantiate()
  add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, dock)
  
  # This gets the issues, and subsequently sets the Issue list.
  var issue_get_api := IssuesGetAPI.new("Evelyn-Hill", "gofetch")
  # You basically have to use signals here because the HTTPRequest class is
  # not awaitable. There is an addon that has an awaitable, but this works fine.
  issue_get_api.request_finished.connect(func(): 
    set_issue_list(issue_get_api.get_issues())
  )
    
#TODO: Dynamically construct return array
#TODO: Send issue data to UI to be displayed
#TODO: Allow issues to be closed or edited via UI? (Maybe)
    
func set_issue_list(issue : Array[Issue]) -> void:
  issue_list = issue
  issue_list_set.emit(issue_list)
  
func _exit_tree() -> void:
  # Clean-up of the plugin goes here.
  remove_control_from_docks(dock)
  remove_control_from_bottom_panel(dock)
  dock.queue_free()
