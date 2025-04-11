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
  fetch_data()
    

func fetch_data() -> String:
  var http : HTTPRequest = HTTPRequest.new()
  get_tree().root.add_child(http)
  http.request("https://api.github.com/repos/Evelyn-Hill/gofetch/issues")
  http.request_completed.connect(handle_request_completed)
  return ""
  
func handle_request_completed(result, response_code, headers, body) -> void:
  if response_code == 200:
    for issue_object in split_response_into_array(body.get_string_from_utf8()):
      var issue : Issue = JsonClassConverter.json_string_to_class(Issue, issue_object)
      if issue:
        issue_list.append(issue)
      else:
        print("FAIL!")
  
#TODO: Dynamically construct return array
#TODO: Send issue data to UI to be displayed
#TODO: Allow issues to be closed or edited via UI? (Maybe)

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
  
  to_return.append(response.substr(0, indicies_for_split[0] - 1).lstrip("[]").rstrip("[]"))
  to_return.append(response.substr(indicies_for_split[0], indicies_for_split[1]).lstrip("[]").rstrip("[]"))
  
  return to_return
    
func _process(delta: float) -> void:
  issue_list_set.emit(issue_list)
  pass
  
func _exit_tree() -> void:
  # Clean-up of the plugin goes here.
  remove_control_from_docks(dock)
  remove_control_from_bottom_panel(dock)
  dock.queue_free()
