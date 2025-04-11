@tool
extends ScrollContainer


@onready var vbox : VBoxContainer = get_node("VBoxContainer")
const ISSUE_SCENE : PackedScene = preload("res://addons/github_issues_integration/Scene/IssueScene.tscn")

var instanced_issues : Dictionary = {}


func _ready() -> void:
  GithubIssues.instance.issue_list_set.connect(on_issue_list_set)

func on_issue_list_set(issue_list : Array[Issue]) -> void:
  # Change this to ID soon
  for issue : Issue in issue_list:
    if not instanced_issues.has(issue.title):
      var my_issue = ISSUE_SCENE.instantiate()
      my_issue.set_issue_data(issue.title, issue.user.login, issue.body)
      vbox.add_child(my_issue)
      instanced_issues[issue.title] = my_issue
    
