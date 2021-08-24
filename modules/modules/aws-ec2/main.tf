provider "aws" {
  alias = "dst"
}

#########
# Labels
########
/*
module "label" {
  source     = "../terraform-label"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
  enabled    = var.enabled
}
*/
# Creating asymmetric keys for ec2instance
resource "aws_key_pair" "key-pair" {
  key_name              = var.key_name
  public_key            = var.public_key
  provider = aws.dst
}





locals {
  is_t_instance_type = replace(var.instance_type, "/^t[23a]{1}\\..*$/", "1") == "1" ? true : false
}

######
# Note: network_interface can't be specified together with associate_public_ip_address
######
resource "aws_instance" "this" {

  count                  = var.instance_count
  
  provider = aws.dst
  ami                    = var.ami
  instance_type          = var.instance_type
 # user_data              = var.user_data
  subnet_id              = distinct(compact(concat([var.subnet_id], var.subnet_ids)))[count.index]
  key_name               = var.key_name
  monitoring             = var.monitoring
  get_password_data      = var.get_password_data
  vpc_security_group_ids = var.vpc_security_group_ids
  
  iam_instance_profile   = var.iam_instance_profile
  root_block_device      {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
  }

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = length(var.private_ips) > 0 ? var.private_ips[count.index] : var.private_ip
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  source_dest_check                    = var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy

  tags = {
    Name = var.ec2_tags
        }
/*
  volume_tags = merge(
    {
     "Name" = "${module.label.namespace}-${module.label.stage}-${module.label.name}-${count.index+1}"
    },
  )
*/
  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }
}

####################################################################
#S3 ROLE VPC3
####################################################################
/*
resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy =  file("${path.module}/assumerolepolicy.json")
  #  assume_role_policy = "${file("assumerolepolicy.json")}"
}
resource "aws_iam_policy" "policy" {
  name        = "s3-policy"
  description = "A test policy"
 # policy      = "${file("policys3bucket.json")}"
  policy =  file("${path.module}/policys3bucket.json")
}

resource "aws_iam_policy_attachment" "s3-attach" {
  name       = "s3-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  # role      = aws_iam_role.ec2_s3_access_role.name
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile"
  #roles= ["${aws_iam_role.ec2_s3_access_role.name}"]
   role = aws_iam_role.ec2_s3_access_role.name
}

*/
