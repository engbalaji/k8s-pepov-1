package env0

default allow = []

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

# Check if the AMI is Amazon Linux 2
ami_check {
	input.ami_id == "ami-0c55b159cbfafe1f0" # Replace with the actual Amazon Linux 2 AMI ID for your region
}

# Allow the build if all checks pass
allow = [check |
    instance_size_check; check = "instance_size_check"
    volume_encryption_check; check = "volume_encryption_check"
    no_public_interface_check; check = "no_public_interface_check"
    ami_check; check = "ami_check"]