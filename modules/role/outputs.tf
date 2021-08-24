output "aws_iam_s3_role" {
#  value       = aws_iam_instance_profile.s3_profile.id
  value  = "${aws_iam_instance_profile.s3_profile.name}"
  description = "List of private subnet IDs"
}

