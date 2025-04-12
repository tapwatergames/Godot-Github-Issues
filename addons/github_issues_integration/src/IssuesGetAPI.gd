class_name IssuesGetAPI
extends HTTPRequest

signal request_finished

var username : String = ""
var reponame : String = ""
# Url format is https://api.github.com/repos/<username>/<reponame>/issues.
var url : String = ""

var _issues : Array[Issue] = []

func _init(username : String, reponame : String) -> void:
  GithubIssues.instance.add_child(self)
  self.username = username
  self.reponame = reponame
  
  url = str("https://api.github.com/repos/", username, "/", reponame, "/issues")
  request_completed.connect(on_request_completed)
  request(url)


func on_request_completed(result, response_code, headers, body) -> void:
  if response_code != 200:
    printerr("Could not retrieve data!")
    return 
  
  for issue_object in split_response_into_array(body.get_string_from_utf8()):
    var issue : Issue = JsonClassConverter.json_string_to_class(Issue, issue_object)
    if issue:
      _issues.append(issue)
  
  request_finished.emit()

func get_issues() -> Array[Issue]:
  self.queue_free()
  return _issues
  
# This method splits the array of JSON objects into individual JSON objects so they
# can be deserialized. 
func split_response_into_array(response : Variant) -> Array[String]:
  var indicies_for_split : Array[int] = []
  var max_count = 21
  var curent_count = 0
  
  # The string we are attempting to match.
  var target_string : String  = ",{\"url\""
  var target_string_size : int = 7

  # Known character sequence for split is },{"url" 
  # split point is directly after the comma, comma should be deleted.

  var index : int = 0
  for char in response:
    index += 1
    if char == "}":
      var possible_string : String = response.substr(index, target_string_size)
      if possible_string == target_string:
        indicies_for_split.append(index + 1)

      
  var to_return : Array[String]

  for idx in indicies_for_split:
    if indicies_for_split.find(idx) == 0:
      to_return.append(response.substr(0, idx).lstrip("[],").rstrip("[],"))
    elif indicies_for_split.find(idx) == indicies_for_split.size():
      to_return.append(response.substr(idx, -1))
    else:
      var idx_diff : int = idx - indicies_for_split[indicies_for_split.find(idx) - 1]
      to_return.append(response.substr(
        indicies_for_split[indicies_for_split.find(idx) - 1], 
        idx_diff).lstrip("[],").rstrip("[],"))
  
  to_return.append(response.substr(indicies_for_split[indicies_for_split.size() - 1], -1).lstrip("[],").rstrip("[],"))
    
  return to_return
  
  
