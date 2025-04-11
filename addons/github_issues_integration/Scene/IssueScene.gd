@tool
class_name IssueScene
extends PanelContainer


func set_issue_data(issue : Issue) -> void:
    %Title.text = issue.title
    %Assignee.text = str(issue.user.login)
    if issue.body == "":
      %Description.text = "no description.."
    else:
      %Description.text = issue.body
    
  
