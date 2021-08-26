resource "aws_iam_role" "ec2_s3_access_role" {
  count  = length(var.iam_role_name)
  name               = var.iam_role_name[count.index]
#  assume_role_policy = "${file("assumerolepolicy.json")}"
  assume_role_policy =  file("${path.module}/assumerolepolicy.json")
}

resource "aws_iam_policy" "policy" {
  count      = length(var.iam_policy_name)
  name        = var.iam_policy_name[count.index]
  description = "A test policy"
 # policy      = "${file("policys3bucket.json")}"
  policy      = file("${path.module}/policys3bucket.json")
}

resource "aws_iam_policy_attachment" "s3-attach" {
  count    = length(var.iam_policy_attachment_name)
  name       = var.iam_policy_attachment_name[count.index]
  roles      = ["${aws_iam_role.ec2_s3_access_role.*.name[count.index]}"]
  # role      = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.policy.*.arn[count.index]
}

resource "aws_iam_instance_profile" "s3_profile" {
  count  = length(var.iam_instance_profile_name)
  name  = var.iam_instance_profile_name[count.index]
  #roles= ["${aws_iam_role.ec2_s3_access_role.name[count.index]}"]
  role = aws_iam_role.ec2_s3_access_role.*.name[count.index]
}


/*
resource "aws_instance" "my-test-instance" {
  ami             = "ami-0dc2d3e4c0f9ebd18"
  instance_type   = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"

  tags = {
    Name = "test-instance"
  }
}
*/
