@tool
extends ScrollContainer


@onready var vbox : VBoxContainer = get_node("VBoxContainer")
const ISSUE_SCENE : PackedScene = preload("res://addons/github_issues_integration/Scene/IssueScene.tscn")

var instanced_issues : Dictionary = {}


func _ready() -> void:
  GithubIssues.instance.issue_list_set.connect(on_issue_list_set)

func on_issue_list_set(issue_list : Array[Issue]) -> void:
  # This handles all of the creation and updating of issue data.
  for issue : Issue in issue_list:
    if not instanced_issues.has(issue.id):
      var my_issue = ISSUE_SCENE.instantiate()
      vbox.add_child(my_issue)
      my_issue.set_issue_data(issue)
      instanced_issues[issue.id] = my_issue
    else:
      var my_issue : IssueScene = instanced_issues[issue.id]
      my_issue.set_issue_data(issue)
    
