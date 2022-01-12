
provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/home/andres/.aws/credentials"
  profile                 = "dacartec"
}

data "cloudinit_config" "server_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/server.yml")
  }
}

resource "aws_instance" "Domino_instance" {
  ami           = "ami-0e8286b71b81c3cc1" // Centos 7 Image  (Must Subscribe before)
  instance_type = "m5.large"
  monitoring    = true
  key_name      = "AWS-Dacartec-Keys"

  subnet_id                   = aws_subnet.some_public_subnet.id
  iam_instance_profile        = aws_iam_instance_profile.dev-resources-iam-profile.name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = data.cloudinit_config.server_config.rendered

  // MAIN Root-Boot Volume
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"

    tags = {
      Name         = "ROOT"
      AttachedTo   = "Domino-AWS-1"
      Author       = "Andres Gorostidi"
      Author-Email = "andres.gorostidi@dacartec.com"
      Environment  = "DEV"
      OS           = "Centos"
      Managed      = "IAC"
      Terraform    = "Yes"
      Customer     = "Internal"
      ProyectCode  = "Mail01"
    }
  }

  tags = {
    Name         = "Domino-AWS-1"
    Author       = "Andres Gorostidi"
    Author-Email = "andres.gorostidi@dacartec.com"
    Environment  = "DEV"
    OS-Release   = "Centos 7.9"
    OS-Type      = "Linux"
    Terraform    = "Yes"
    Customer     = "Internal"
    ProyectCode  = "Mail01"
  }
}


// IMPORTANTE -  Volumenes Deben empezarse siempre por sdf

// OPT VolumeF,  where product is installed
resource "aws_ebs_volume" "awsvolumeF" {
  availability_zone = "eu-central-1a"
  size              = 10
  type              = "gp3"
  encrypted         = "false"

  tags = {
    Name         = "OPT"
    AttachedTo   = "Domino-AWS-1"
    Author       = "Andres Gorostidi"
    Author-Email = "andres.gorostidi@dacartec.com"
    Environment  = "DEV"
    Terraform    = "Yes"
    Customer     = "Internal"
    ProyectCode  = "Mail01"
  }
}

resource "aws_volume_attachment" "volumeF" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.Domino_instance.id
  volume_id   = aws_ebs_volume.awsvolumeF.id
}


// LOCAL VolumeG,  where Domino stores his databases and config  (ie, /local/notesdata)
resource "aws_ebs_volume" "awsvolumeG" {
  availability_zone = "eu-central-1a"
  size              = 200
  type              = "gp3"
  encrypted         = "false"

  tags = {
    Name         = "LOCAL"
    AttachedTo   = "Domino-AWS-1"
    Author       = "Andres Gorostidi"
    Author-Email = "andres.gorostidi@dacartec.com"
    Environment  = "DEV"
    Terraform    = "Yes"
    Customer     = "Internal"
    ProyectCode  = "Mail01"
  }
}


resource "aws_volume_attachment" "volumeG" {
  device_name = "/dev/sdg"
  instance_id = aws_instance.Domino_instance.id
  volume_id   = aws_ebs_volume.awsvolumeG.id
}

// VolumeH for DAOS Storage
resource "aws_ebs_volume" "awsvolumeH" {
  availability_zone = "eu-central-1a"
  size              = 240
  type              = "gp3"
  encrypted         = "false"

  tags = {
    Name         = "DAOS"
    AttachedTo   = "Domino-AWS-1"
    Author       = "Andres Gorostidi"
    Author-Email = "andres.gorostidi@dacartec.com"
    Environment  = "DEV"
    Terraform    = "Yes"
    Customer     = "Internal"
    ProyectCode  = "Mail01"
  }
}

resource "aws_volume_attachment" "volumeH" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.Domino_instance.id
  volume_id   = aws_ebs_volume.awsvolumeH.id
}

// High Perfomance VolumeI for TRANSLOG
resource "aws_ebs_volume" "awsvolumeI" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp3"
  iops              = 5000
  encrypted         = "false"

  tags = {
    Name         = "TRANSLOG"
    AttachedTo   = "Domino-AWS-1"
    Author       = "Andres Gorostidi"
    Author-Email = "andres.gorostidi@dacartec.com"
    Environment  = "DEV"
    Terraform    = "Yes"
    Customer     = "Internal"
    ProyectCode  = "Mail01"
  }
}

resource "aws_volume_attachment" "volumeI" {
  device_name = "/dev/sdi"
  instance_id = aws_instance.Domino_instance.id
  volume_id   = aws_ebs_volume.awsvolumeI.id
}

// High Perfomance VolumeJ for views (NIFBasePath, FTBasePath and VIEW_REBUILD_DIR)
resource "aws_ebs_volume" "awsvolumeJ" {
  availability_zone = "eu-central-1a"
  size              = 40
  type              = "gp3"
  iops              = 4000
  encrypted         = "false"

  tags = {
    Name         = "VIEWS"
    AttachedTo   = "Domino-AWS-1"
    Author       = "Andres Gorostidi"
    Author-Email = "andres.gorostidi@dacartec.com"
    Environment  = "DEV"
    Terraform    = "Yes"
    Customer     = "Internal"
    ProyectCode  = "Mail01"
  }
}

resource "aws_volume_attachment" "volumeJ" {
  device_name = "/dev/sdj"
  instance_id = aws_instance.Domino_instance.id
  volume_id   = aws_ebs_volume.awsvolumeJ.id
} 