output "notebook_instance_name" {
  description = "Name of the SageMaker notebook instance"
  value       = aws_sagemaker_notebook_instance.sagemaker_notebook_instance.name
}

output "notebook_instance_arn" {
  description = "ARN of the SageMaker notebook instance"
  value       = aws_sagemaker_notebook_instance.sagemaker_notebook_instance.arn
}

output "notebook_instance_url" {
  description = "URL to open the notebook instance"
  value       = aws_sagemaker_notebook_instance.sagemaker_notebook_instance.url
}

output "network_interface_id" {
  description = "Network interface ID attached to the notebook instance"
  value       = aws_sagemaker_notebook_instance.sagemaker_notebook_instance.network_interface_id
}
