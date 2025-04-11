@tool
class_name IssueScene
extends PanelContainer


func set_issue_data(
  title : String, 
  author : String, 
  description : String) -> void:
    %Title.text = title
    %Author.text = author
    if description == "":
      %Description.text = "no description.."
    else:
      %Description.text = description
    
  
