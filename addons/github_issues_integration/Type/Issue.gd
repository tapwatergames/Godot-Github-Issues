@tool
class_name Issue
extends RefCounted

var id : int
var node_id : String
var url : String
var repository_url : String
var labels_url : String
var comments_url : String
var events_url : String
var html_url : String
var number : int
var state : String
var title : String
var body : String
var user : User
var labels : Array[GithubLabel]
var assignee : User
var assignees : Array[User]

func is_open(open : bool) -> void:
  if open:
    state = "open"
  else:
    state = "closed"
  


  
  
