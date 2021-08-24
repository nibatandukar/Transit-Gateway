resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role-1"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}
resource "aws_iam_policy" "policy" {
  name        = "s3-policy-1"
  description = "A test policy"
  policy      = "${file("policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "s3-attach" {
  name       = "s3-attachment-1"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  # role      = aws_iam_role.ec2_s3_access_role.name
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile-1"
  #roles= ["${aws_iam_role.ec2_s3_access_role.name}"]
  role = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_instance" "my-test-instance" {
  ami             = "ami-0dc2d3e4c0f9ebd18"
  instance_type   = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"

  tags = {
    Name = "test-instance"
  }
}
