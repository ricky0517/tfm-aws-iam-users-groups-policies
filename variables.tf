variable "users" {
  default = [ "raj", "ricky" ]
}

variable "groups" {
  default = [ "personal", "professional", "sports"]
}

variable "user_group_assignments" {
  default = {
    "raj"   = [ "personal", "sports" ]
    "ricky" = [ "professional" ]
  }
}

