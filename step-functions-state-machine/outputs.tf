output "state_machine_id" {
  description = "ID of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.id
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.arn
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.name
}

output "state_machine_creation_date" {
  description = "Creation date of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.creation_date
}
