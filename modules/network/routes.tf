resource "aws_route_table" "public_alb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "rt-public-alb"
  })
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "rt-private-app"
  })
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "rt-private-db"
  })
}

resource "aws_route_table_association" "public_alb" {
  for_each = aws_subnet.public_alb

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_alb.id
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table_association" "private_db" {
  for_each = aws_subnet.private_db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}
