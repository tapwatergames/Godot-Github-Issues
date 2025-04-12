class_name ImageGetAPI
extends HTTPRequest

signal image_retrieved

var itex : ImageTexture

func _init(issue : IssueScene) -> void:
  issue.add_child(self)

func retrieve_image(url : String) -> void:
  request_completed.connect(on_image_retrieved)
  request(url)

func on_image_retrieved(result, response_code, headers, body) -> void:
  if response_code != 200:
    printerr("Could not load image at!")
    return
  
  var img : Image = Image.new()
  img.load_jpg_from_buffer(body)
  img.resize(35,35)
  itex = ImageTexture.new()
  itex = itex.create_from_image(img)
  image_retrieved.emit()

func get_image() -> ImageTexture:
  self.queue_free()
  return itex
