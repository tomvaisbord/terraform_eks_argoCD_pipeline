resource "aws_iam_policy" "eks_termination_policy" {
  name        = "EKS_TerminationPolicy"
  description = "Policy allowing necessary EC2 termination and VPC teardown actions for EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DetachInternetGateway",
          "ec2:DeleteNatGateway",
          "ec2:ReleaseAddress",
          "ec2:DeleteRoute",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances"
        ],
        Resource = "*"
      }
    ]
  })
}
