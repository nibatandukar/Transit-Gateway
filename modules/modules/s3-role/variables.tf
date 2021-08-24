variable "iam_role_name" {
  type = list(string)
 #  default = ["s3-role-prod", "s3-role-dr"]
  default = []
}
   

variable "iam_policy_name" {
  type = list(string)
  default = ["s3-policy-prod"]
}

variable "iam_policy_attachment_name" {
  type = list(string)
  default = ["s3-policy_attachment_name_prod"]
}

variable "iam_instance_profile_name" {
  type = list(string)
  default = ["s3-profile-prod"]
}
