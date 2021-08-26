data "aws_route_tables" "rts" {
  vpc_id = var.vpc_id
}

resource "aws_route" "tgw-route-1" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-1
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-2" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-2
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-3" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-3
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-4" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-4
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-5" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-5
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-6" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-6
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-7" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-7
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "tgw-route-8" {
  count                     = length(data.aws_route_tables.rts.ids)
  route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = var.tgw-route-cidr-8
  transit_gateway_id        = var.transit_gateway_id
}

resource "null_resource" "dependency" {
  triggers = {
    dependency_id = var.transit_gateway_id
  }
 provisioner "local-exec" {
    # We need a sleep 30 here to give the Organization, child accounts and the IAM roles within them time to be created
    command = "python -c 'import time; time.sleep(60)'"
  }
}

variable "vpc_id" {}

variable "transit_gateway_id" {}

variable "tgw-route-cidr-1" {}

variable "tgw-route-cidr-2" {}

variable "tgw-route-cidr-3" {}

variable "tgw-route-cidr-4" {}

variable "tgw-route-cidr-5" {}

variable "tgw-route-cidr-6" {}

variable "tgw-route-cidr-7" {}

variable "tgw-route-cidr-8" {}
