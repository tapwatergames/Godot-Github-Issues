@tool
class_name Issue
extends RefCounted

@export var id : int
@export var node_id : String
@export var url : String
@export var repository_url : String
@export var labels_url : String
@export var comments_url : String
@export var events_url : String
@export var html_url : String
@export var number : int
@export var state : String
@export var title : String
@export var body : String
@export_storage var user : User
@export_storage var labels : Array[GithubLabel]
@export_storage var assignee : User
@export_storage var assignees : Array[User]

func is_open(open : bool) -> void:
  if open:
    state = "open"
  else:
    state = "closed"
  


  
  
