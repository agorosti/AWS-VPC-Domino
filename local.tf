#IP of aws instance copied to a file ip.txt in local system
resource "local_file" "ip" {
  content  = aws_instance.Domino_instance.id
  filename = "ip.txt"
}