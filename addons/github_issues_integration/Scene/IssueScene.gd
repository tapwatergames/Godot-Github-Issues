@tool
class_name IssueScene
extends PanelContainer

var issue : Issue


func _ready() -> void:
  %CloseButton.pressed.connect(handle_closed_pressed)

func set_issue_data(issue : Issue) -> void:
    self.issue = issue
    %Title.text = issue.title
    %Owner.text = str("Owner: ", issue.user.login)
    if issue.body == "":
      %Description.text = "no description.."
    else:
      %Description.text = issue.body
    var img_api : ImageGetAPI = ImageGetAPI.new(self)
    img_api.retrieve_image(issue.user.avatar_url)
    await img_api.image_retrieved
    var texture = img_api.get_image()
    %Image.texture = texture
    
func handle_closed_pressed() -> void:
  issue.is_open(false)
  # Do JSON serlialization and post
  # Tell thing to refresh issues.
  pass


  
    
  
