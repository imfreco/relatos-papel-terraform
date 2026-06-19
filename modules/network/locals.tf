locals {
  az_keys = ["a", "b"]

  availability_zones = {
    a = var.az_a
    b = var.az_b
  }

  public_alb_subnets = {
    a = {
      cidr_block = "10.0.1.0/24"
      name       = "public-alb-a"
    }
    b = {
      cidr_block = "10.0.2.0/24"
      name       = "public-alb-b"
    }
  }

  private_app_subnets = {
    a = {
      cidr_block = "10.0.11.0/24"
      name       = "private-app-a"
    }
    b = {
      cidr_block = "10.0.12.0/24"
      name       = "private-app-b"
    }
  }

  private_db_subnets = {
    a = {
      cidr_block = "10.0.21.0/24"
      name       = "private-db-a"
    }
    b = {
      cidr_block = "10.0.22.0/24"
      name       = "private-db-b"
    }
  }
}
