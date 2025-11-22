output "minikube_instance_id" {
  description = "ID of the Minikube EC2 instance"
  value       = aws_instance.minikube.id
}

output "minikube_public_ip" {
  description = "Public IP of the Minikube EC2 instance"
  value       = aws_instance.minikube.public_ip
}

output "minikube_public_dns" {
  description = "Public DNS of the Minikube EC2 instance"
  value       = aws_instance.minikube.public_dns
}
