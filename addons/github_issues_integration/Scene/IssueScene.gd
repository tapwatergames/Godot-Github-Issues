@tool
class_name IssueScene
extends PanelContainer


func set_issue_data(issue : Issue) -> void:
    var image : Image = Image.new()
    image.load(issue.user.avatar_url)
    var itex : ImageTexture = ImageTexture.new()
    itex = itex.create_from_image(image)
    var texture : Texture2D = itex
    %Title.text = issue.title
    %Assignee.text = str(issue.user.login, " ", "[img]", image.load(issue.user.avatar_url), "[/img]")
    if issue.body == "":
      %Description.text = "no description.."
    else:
      %Description.text = issue.body
    
  
