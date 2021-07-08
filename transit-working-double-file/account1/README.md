## Account1

* Name to be used on all the resources as identifier
```
variable "name" {
  type        = string
  default     = ""
}
```

* The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
```
variable "cidr" {
  type        = string
  default     = "0.0.0.0/0"
}
```

* A list of availability zones names or ids in the region
```
variable "azs" {
  type        = list(string)
  default     = []
}
```

* A list of private subnets inside the VPC
```
variable "private_subnets" {
  type        = list(string)
  default     = []
}
```

* Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block
```
variable "enable_ipv6" {
  type        = bool
  default     = false
}
```

* Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
```
variable "private_subnet_assign_ipv6_address_on_creation" {
  type        = bool
  default     = null
}
```

* Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet listprivate_subnet_assign_ipv6_address_on_creation
```
variable "private_subnet_ipv6_prefixes" {
  type        = list(string)
  default     = []
}
```

* Assign the CIDR in the route table of subnet
```
variable "tgw-route-cidr" {
  type = string
  default = ""
}
```

## Transit Gateway of account1

* Name to be used on all the resources as identifier
```
variable "name" {
  type        = string
  default     = ""
}
```

* Whether resource attachments are automatically associated with the default association route table
```
variable "enable_default_route_table_association" {
  type        = bool
  default     = true
}
```

* Whether resource attachment requests are automatically accepted
```
variable "enable_auto_accept_shared_attachments" {
  type        = bool
  default     = false
}
```

* Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform.
```
variable "vpc_attachments" {
  type        = any
  default     = {}
}
```

* Indicates whether principals outside your organization can be associated with a resource share
```
variable "ram_allow_external_principals" {
  type        = bool
  default     = false
}
```

* A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN
```
variable "ram_principals" {
  type        = list(string)
  default     = []
}
```

