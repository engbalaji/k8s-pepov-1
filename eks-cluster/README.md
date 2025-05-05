# How to build this thing

## Initialize terraform
To deploy this stack, you need to first set your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. If this is being done via Jenkins, you should be able to do this using a `withCredentials` call, otherwise you can populate those from IAM Identity Center.

From there, run the following command, replacing values as needed. Note the following:

* s3 bucket name should be the bucket used to hold the state for the terraform stack
* region is of course the region the bucket resides in - this does not have to be the same as where the resources are being deployed
* key should be unique - this is the file name used for the state within the bucket, and duplicating this could lead to state problems between stacks; ye be warned

`terraform init -backend-config="bucket=[s3 bucket name]" -backend-config="region=[region for the bucket]" -backend-config="key=[object key]"`

## Get your deployment plan ready

Before you proceed, you'll need to know a couple pieces of information, all documented in the `vars.tf` file. Of note, the AMI ID should be on the same kubernetes version or one version behind what the cluster will be, and should be a hardened image. When in doubt, ask one of the cloudy boys or girls, or maybe ask Derik.

Additionally, this template will allow for pulling from a variety of instance types based on predefined spec requirements. This is where the `min_node_` and `max_node_` variables come in.

Beyond that, here is a summary of the variables below.

| Variable                  | Description                                                                                                                                                                                                                                                        | Example                                                                                                              |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| `aws_region`              | What region are we deploying into? Typically will be `us-west-2`.                                                                                                                                                                                                  | `us-west-2`                                                                                                          |
| `vpc_id`                  | What VPC is this stack going into?                                                                                                                                                                                                                                 | `vpc-1234567890abcdef`                                                                                               |
| `subnet_id_a`             | This should be a private subnet ID in the `[region]-a` subnet.                                                                                                                                                                                                     | `subnet-abcdef1234567890`                                                                                            |
| `subnet_id_b`             | Similar to `subnet_id_a`.                                                                                                                                                                                                                                          | `subnet-0987654321fedcba`                                                                                            |
| `environment`             | What environment does this cluster serve? For example, `devc`, `prod`, etc.                                                                                                                                                                                        | `devc`                                                                                                               |
| `kubernetes_version`      | Version of Kubernetes to run in the cluster, like `1.30`.                                                                                                                                                                                                           | `1.30`                                                                                                               |
| `cloud_services_role_arn` | IAM role ARN string for the cloud services team. Should look something like this: `arn:aws:iam::<account-id>:role/aws-reserved/sso.amazonaws.com/<region>/AWSReservedSSO_AWSAdministratorAccess_<identifier>`                                                      | `arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_AWSAdministratorAccess_abcde` |
| `alternate_role_arn`      | Similar to `cloud_services_role_arn`, but for granting another team read access to the cluster. This will typically be the webmt team, and formatted similarly to the `cloud_services_role_arn` variable.                                                           | `arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_ReadOnlyAccess_abcde`         |
| `ami_id`                  | AMI ID to use for worker nodes in the cluster. See the long-ish note at the beginning of this section.                                                                                                                                                             | `ami-0abcdef1234567890`                                                                                              |
| `min_node_cpu_count`      | Minimum number of CPU cores per EKS worker node.                                                                                                                                                                                                                   | `2`                                                                                                                  |
| `max_node_cpu_count`      | Maximum number of CPU cores per EKS worker node.                                                                                                                                                                                                                   | `8`                                                                                                                  |
| `min_node_mem_GiB`        | Minimum amount of RAM in GiB per EKS worker node.                                                                                                                                                                                                                  | `4`                                                                                                                  |
| `max_node_mem_GiB`        | Maximum amount of RAM in GiB per EKS worker node.                                                                                                                                                                                                                  | `16`                                                                                                                 |
| `cluster_min_capacity`    | Minimum number of worker nodes for the EKS cluster.                                                                                                                                                                                                                | `1`                                                                                                                  |
| `cluster_max_capacity`    | Maximum number of worker nodes for the EKS cluster.                                                                                                                                                                                                                | `5`                                                                                                                  |
| `cluster_cidr`            | Network CIDR to handle internal networking within the Kubernetes cluster. This should fall within `10.0.0.0/8`, `172.16.0.0/12` or `192.168.0.0/16`. Avoid using anything within the `10.0.0.0/8` space unless you know for a fact that this cluster will have no need to communicate with the rest of the corporate network. | `172.16.0.0/16`                                                                                                      |

To plan the deployment, you can do one of two things, shown below.

### Create a `[something].tfvars` file and pass it into your plan command.

To create a .tfvars file, format it like shown below, where the part before the `=` is the variable name, and after is the value.

```
aws_region=us-west-2
vpc_id=vpc-1234567890abcdef
...
```

Once you have that, you can run the command below to create a terraform plan and output it to a file called `tfplan`. The `-no-color` flag isn't required, but is helpful for proper formatting within automation. We're assuming the file is called `some-file.tfvars`.

`terraform plan -var-file='some-file.tfvars' -out='tfplan' -no-color`

Gentle all-caps reminder, but DO NOT STORE SECRETS IN PLAINTEXT, and DO NOT STORE SECRETS IN VERSION CONTROL.

### Pass variables directly into your plan command.

If you want to forgo the .tfvars file, you can also do an inline version of the command, like below. For brevity, I'll include only a couple variables, but you can use any combination of them.

`terraform plan -var 'aws_region=us-west-2' -var 'vpc_id=1234567890abcdef' -out='tfplan' -no-color`.

Obviously, if you specify a large number of variables, this could lead to rather long commands.

## Run the plan

Okay, you've got your plan. If it looks good, it's time to deploy it. No matter which approach you took above to create your plan, from here the deployment is the same. Assuming your plan file is called `tfplan`, simply run the command below.

`terraform apply -input=false -no-color -auto-approve tfplan`

Now just sit back with a snack and drink, since this could take a little while. From this point though, assuming your parameters are good, everything should just build.

## Updating the stack

Simply repeat the steps above to complete a deployment, updating variables accordingly or potentially changing the terraform templates. Obviously, review the plan prior to performing the update to ensure all works as you would expect.

## Clean up

Cleanup is virtually identical to building, in that you will perform both a plan and apply. When creating the plan, add the `-destroy` flag to the end of your `terraform plan` command, but otherwise the steps are identical. Obviously, be careful when running a destroy. It's a one-way street, and does come with the risk of outages, data loss, werewolves, zombies and angry incident managers. Proceed with caution.