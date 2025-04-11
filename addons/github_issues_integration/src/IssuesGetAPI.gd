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
  
  
