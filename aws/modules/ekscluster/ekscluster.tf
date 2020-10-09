resource "random_pet" "prefix" {
}

resource "eks_cluster" "example" {
  name     = "${random_pet.prefix.id}-rg"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = [aws_subnet.example1.id, aws_subnet.example2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController
  ]

  tags = {
    environment = "cloudguard-k8s-demo"
  }
}
