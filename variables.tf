data "template_file" "init"{
  vars = {
    AWS_ACESS_KEY = var.AWS_ACESS_KEY
    AWS_SECRET_KEY = var.AWS_SECRET_KEY
  }
}
variable "AWS_ACESS_KEY" {
  description     = "Acess AWS"
}
variable "AWS_SECRET_KEY" {
  description     = "Secret AWS"
}
########## Security Group ##########
variable "security_group" {
  type = map(object({
    name        = string
    description = string
    tag         = map(string)
  }))
  description = "valores para criacao de SG"
  default = {
    # SG FLAPS
    flaps = {
      name        = "client-01"
      description = "securit group do client-01"
      tag = {
        Name = "client-01"
        ENVIRONMENT       = "DEV"
        SQUAD = "FLAPS"
      }
    }
    # SG LANNISTERS
    lannisters = {
      name        = "dev-lannisters"
      description = "securit group da squad lannisters"
      tag = {
        Name = "dev-lannisters"
        ENVIRONMENT       = "DEV"
        SQUAD = "LANNISTERS"
      }
    }
  }
}
####################################
variable "ingress_rules" {
  type = map(object({
    security_group_id            = string
    from_port                    = number
    to_port                      = number
    protocol                     = string
    description                  = string
    cidr                         = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = {
    # SG FLAPS
    flaps = {
      security_group_id = "flaps"
      from_port         = 0
      to_port           = 65535
      protocol          = "tcp"
      description       = "TCP ALL FOR VPN"
      cidr              = "10.100.0.0/16"
      # adicionar segunda regra de entrada !!
    }
    # SG LANNISTERS
    lannisters = {
      security_group_id = "lannisters"
      from_port         = 0
      to_port           = 65535
      protocol          = "tcp"
      description       = "TCP ALL FOR VPN"
      cidr              = "10.100.0.0/16"
    }
  }
  description = "Regras de entrada do grupo de segurança"
}

########## EC2 ##########
variable "instances" {
  type = map(object({
    ami               = string
    instance_type     = string
    security_group_id = string
    user_data = string
    tag         = map(string)
  }))
  default = {
    # EC2 123MILHAS - FLAPS
    flaps = {
      ami               = "ami-00a2e89e4543955e8"
      instance_type     = "m6a.large"
      security_group_id = "flaps"
      user_data = "data/flaps.sh"
      tag = {
        Name = "DEV-123MILHAS-FLAPS"
        SQUAD = "FLAPS"
        ENVIRONMENT       = "DEV"
        PROJECT_123MILHAS = "TRUE"
      }
    }
    # EC2 BUSCAFACIL - FLAPS
    flaps_bf = {
      ami               = "ami-051b3e231081838c6" 
      instance_type     = "t2.small" 
      security_group_id = "flaps"
      user_data = "data/flaps_bf.sh"
      tag = {
        Name = "DEV-BUSCAFACIL-FLAPS"
        SQUAD = "FLAPS"
        ENVIRONMENT       = "DEV"
        PROJECT_BUSCAFACIL = "TRUE"
      }
    }
  }
}

########## REDIS ##########
variable "redis" {
  type = map(object({
    cluster_id         = string
    security_group_ids = string
    tag         = map(string)
  }))
  default = {
    # REDIS FLAPS
    flaps = {
      cluster_id         = "client-01"
      security_group_ids = "flaps"
      tag = {
        Name = "client-01"
        ENVIRONMENT       = "DEV"
      }
    }
    # REDIS LANNISTERS
    lannisters = {
      cluster_id         = "dev-lannisters"
      security_group_ids = "lannisters"
      tag = {
        Name = "dev-lannisters"
        ENVIRONMENT       = "DEV"
        SQUAD = "LANNISTERS"
      }
    }
  }
}

# EC2 TYPE
variable "instance_type" {
  default = "t2.small"
}