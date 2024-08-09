provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  master_username         = "admin"
  master_password         = "yourpassword"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = true
}

resource "aws_security_group" "aurora_sg" {
  name        = "aurora_sg"
  description = "Allow public access to Aurora"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
