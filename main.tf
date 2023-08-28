########## Security Group ##########
resource "aws_security_group" "security_group" {
  for_each    = var.security_group
  name        = each.value.name
  description = each.value.description
  vpc_id      = "vpc-77ec020c"
  tags        = each.value.tag
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each                     = var.ingress_rules
  security_group_id            = aws_security_group.security_group[each.value.security_group_id].id
  cidr_ipv4                    = each.value.cidr
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.protocol
  to_port                      = each.value.to_port
  description                  = each.value.description
  referenced_security_group_id = each.value.referenced_security_group_id
}
####################################

########## EC2 ##########
resource "aws_instance" "ec2" {
  for_each = var.instances
  key_name = "plataforma13"
  ami           = each.value.ami
  instance_type = each.value.instance_type
  tags        = each.value.tag
  user_data     = file(each.value.user_data)
  vpc_security_group_ids = [aws_security_group.security_group[each.value.security_group_id].id]
}
####################################

########## REDIS ##########
resource "aws_elasticache_cluster" "redis" {
  for_each = var.redis
  cluster_id           = each.value.cluster_id
  engine               = "redis"
  node_type            = "cache.t4g.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  tags        = each.value.tag
  security_group_ids   = [aws_security_group.security_group[each.value.security_group_ids].id]
}
####################################

########## SQS ##########
resource "aws_sqs_queue" "dev-queue-alcateia" { # SQS ALCATEIA
  name = "dev-queue-alcateia"
}
resource "aws_sqs_queue" "dev-queue-lannisters" { # SQS LANNISTERS
  name = "dev-queue-lannisters"
}
resource "aws_sqs_queue" "dev-queue-alquimistas" { # SQS ALQUIMISTAS
  name = "dev-queue-alquimistas"
}