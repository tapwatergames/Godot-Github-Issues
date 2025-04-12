class_name IssuePatchAPI
extends HTTPRequest

func _init(issue : IssueScene) -> void:
  issue.add_child(self)

func request_patch(username : String, reponame : String, issue : Issue) -> void:
  # First we need to construct URL
  var url : String = str("https://api.github.com/repos/", username, "/", reponame, "/issues/", issue.number)
  # Serialize the issue class
  var issue_string = JsonClassConverter.class_to_json_string(issue)
  request_completed.connect(on_requst_completed)
  request(url, PackedStringArray(["accept:application/vnd.github+json"]), HTTPClient.METHOD_PATCH, issue_string)
  
func on_requst_completed(result, response_code, headers, body) -> void:
  print(response_code)
  print(body.get_string_from_utf8())
  
