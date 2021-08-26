output "aws_iam_s3_role" {
  value  = "${aws_iam_instance_profile.s3_profile[0].name}"
  description = "List of private subnet IDs"
}
/*
output "aws_iam_s3_role_dr" {
  value  = "${aws_iam_instance_profile.s3_profile[1].name}"
  description = "List of private subnet IDs"
}
*/
