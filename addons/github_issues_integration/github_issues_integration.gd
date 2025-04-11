@tool
class_name GithubIssues
extends EditorPlugin

var dock

static var instance : GithubIssues

var issue_list : Array[Issue] : 
  set(value):
    issue_list = value
    issue_list_set.emit(value)

signal issue_list_set(issue_list : Array[Issue])

var user : String
var repository : String

func _enter_tree() -> void:
  instance = self
  # Initialization of the plugin goes here.
  dock = preload("res://addons/github_issues_integration/Scene/dock.tscn")
  dock = dock.instantiate()
  add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, dock)
  var item_0 := split_response_into_array(fetch_data())[0]
  var issue : Issue  = JsonClassConverter.json_string_to_class(Issue, item_0)
  if not issue:
    push_error("Could not convert")
  else: 
    print(issue.id)
    print(JsonClassConverter.class_to_json(issue))
    issue_list.append(issue)
    

func fetch_data() -> String:
  var response := []
  var exit_code := OS.execute(
    "curl", 
    [
      "-L",
      "-H Accept: application/vnd.github+json", 
      "-H Authorization: Bearer <YOUR-TOKEN>",
      "-H X-GitHub-Api-Version: 2022-11-28",
      "https://api.github.com/repos/Evelyn-Hill/gofetch/issues"
    ], 
    response)
  
  #print(split_response_into_array(response[0])[0])
    
  return response[0]
  
func split_response_into_array(response : Variant) -> Array[String]:
  var indicies_for_split : Array[int] = []
  var max_count = 21
  var curent_count = 0
  
  var index : int = 0
  for char in response:
    index += 1
    if char == "}":
      #print("close")
      if curent_count != max_count:
        curent_count += 1
        #print(curent_count)
      else:
        indicies_for_split.append(index + 1)
        curent_count = 0
        
  var to_return : Array[String]
  
  to_return.append(response.substr(0, indicies_for_split[0]).lstrip("[]"))
  to_return.append(response.substr(indicies_for_split[0], indicies_for_split[1]))
  
  return to_return
    
func _process(delta: float) -> void:
  #issue_list_set.emit(issue_list)
  pass
  
func _exit_tree() -> void:
  # Clean-up of the plugin goes here.
  remove_control_from_docks(dock)
  remove_control_from_bottom_panel(dock)
  dock.queue_free()
