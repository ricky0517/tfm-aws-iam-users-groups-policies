# Create users
resource "aws_iam_user" "users" {
  for_each = { for user in var.users : user => user }  

  name = each.key
}

# Create groups
resource "aws_iam_group" "groups" {
  for_each = { for group in var.groups : group => group }  

  name = each.key
}

# Assign users to groups
resource "aws_iam_user_group_membership" "group_membership" {
  for_each = var.user_group_assignments

  user = each.key
  groups = each.value

  depends_on = [ aws_iam_user.users, aws_iam_group.groups ]
}

variable "group_policy_assignments" {
  default = {
   "personal"     = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess"],
   "professional" = ["arn:aws:iam::aws:policy/AmazonRDSFullAccess"]
  }
}

locals {
  group_policy_assignments = flatten([
    for g, policies in var.group_policy_assignments : [
      for p in policies : {
        group = g
        policy = p
      }
    ]
  ])
}

resource "aws_iam_group_policy_attachment" "group_policy_attachments" {
  for_each = { for gpa in local.group_policy_assignments : "${gpa.group}--${gpa.policy}" => gpa.policy  }

  group      = split("--", each.key)[0]
  policy_arn = each.value

  depends_on = [ aws_iam_group.groups ]
}