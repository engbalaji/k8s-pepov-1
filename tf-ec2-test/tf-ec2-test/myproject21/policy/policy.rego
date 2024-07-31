package env0

# Define the allowed instance types
allowed_instance_types = {"t2.micro", "t2.small", "t2.medium"}

# Deny EC2 instance creation if EBS encryption is not enabled
deny[msg] {
    input.request.operation == "RunInstances"
    some i
    not input.request.parameters.BlockDeviceMappings[i].Ebs.Encrypted
    msg := "EBS encryption must be enabled for all instances."
}

# Deny EC2 instance creation if the instance type is not allowed
deny[msg] {
    input.request.operation == "RunInstances"
    not allowed_instance_types[input.request.parameters.InstanceType]
    msg := sprintf("Instance type %s is not allowed.", [input.request.parameters.InstanceType])
}

# Deny EC2 instance creation if a public IP address is assigned
deny[msg] {
    input.request.operation == "RunInstances"
    some i
    input.request.parameters.NetworkInterfaces[i].AssociatePublicIpAddress == true
    msg := "Instances must not have a public IP address."
}