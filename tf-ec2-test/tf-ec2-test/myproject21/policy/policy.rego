package env0

default allow = false

# Check if the instance type is larger than t3.medium
instance_size_check {
	input.instance_type != "t3.medium"
	input.instance_type != "t3.small"
	input.instance_type != "t3.micro"
	input.instance_type != "t3.nano"
}

# Check if the EBS volume is encrypted
volume_encryption_check {
	input.ebs_volume_encrypted == true
}

# Check if the instance is not attached to a public interface
no_public_interface_check {
	input.public_ip == false
}

# Allow the build if all checks pass
allow {
	instance_size_check
	volume_encryption_check
	no_public_interface_check
}