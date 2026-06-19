resource "aws_subnet" "public_alb" {
  for_each = local.public_alb_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = local.availability_zones[each.key]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = each.value.name
    Tier = "public-alb"
  })
}

resource "aws_subnet" "private_app" {
  for_each = local.private_app_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = local.availability_zones[each.key]

  tags = merge(var.common_tags, {
    Name = each.value.name
    Tier = "private-app"
  })
}

resource "aws_subnet" "private_db" {
  for_each = local.private_db_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = local.availability_zones[each.key]

  tags = merge(var.common_tags, {
    Name = each.value.name
    Tier = "private-db"
  })
}
