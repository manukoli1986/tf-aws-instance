# tf-aws-instance
Launch Single EC2 instance with terraform code

Terrafrom AWS Provider configure
Different ways 
The AWS provider offers a flexible means of providing credentials for authentication. The following methods are supported, in this order, and explained below:
•	Static credentials – To simply add credential in file. It may be at risk  
i.e. Static credentials can be provided by adding an access_key and secret_key in-line in the AWS provider block:
Usage:
```
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
```
•	Environment variables
You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively. Note that setting your AWS credentials using either these (or legacy) environment variables will override the use of AWS_SHARED_CREDENTIALS_FILE and AWS_PROFILE. The AWS_DEFAULT_REGION and AWS_SESSION_TOKEN environment variables are also used, if applicable:
```
provider "aws" {}
Usage:
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
$ terraform plan
```
•	Shared credentials file
We can configured it via command line which will generate a file in your local with information. 
### aws configure
```
AWS Access Key ID [****************ble:]: XXXXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXXX
Default region name [provider "aws" {}]: ap-XXXX-X
Default output format [Usage:]:
```

To get output
### aws configure get aws_access_key_id

Once you are ready with credential then you can communicate with cloud provider AWS using terrafrom tool and it will do whatever you will write in code. 
Let’s preform this.
You will get an issue if you are running terrafrom first time. 
```
#####ISSUE #####
# terraform plan
Plugin reinitialization required. Please run "terraform init".
Reason: Could not satisfy plugin requirements.

Plugins are external binaries that Terraform uses to access and manipulate
resources. The configuration provided requires plugins which can't be located,
don't satisfy the version constraints, or are otherwise incompatible.

1 error occurred:
        * provider.aws: no suitable version installed
  version requirements: "(any version)"
  versions installed: none



Terraform automatically discovers provider requirements from your
configuration, including providers used in child modules. To see the
requirements and constraints from each module, run "terraform providers".


Error: error satisfying plugin requirements


[07:32:11 root@vagrantbox:/vagrant/tf-aws-instance] # terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (2.33.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.33"

Terraform has been successfully initialized!
```

So we had to initialize terrafrom init stage first....

################################
Now run create below file to which will be acted as key/core object to AWS. Otherwise AWS would not be able to understand who is trying to talking to them.
I have used 2 files (Main and variable). Make sure you follow the same way which will keep you code clean and easy to understand for others. 
```
cat main.tf
provider "aws" {
  region = "us-east-1"
}


resource "aws_key_pair" "mayank-user" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
[07:45:35 root@vagrantbox:/vagrant/tf-aws-instance] # cat variable.tf
variable "AWS_ACCESS_KEY_ID" {
    default = "$(aws configure get aws_access_key_id)"
    }
variable "AWS_SECRET_ACCESS_KEY" {
    default = "$(aws configure get aws_secret_access_key)"
    }
variable "aws_region" {
    default = "$(aws configure get region)"
    }
```
Hope you are clear with above commands. I have declare the values in variable file. 

Once you run below command. You will get output like this. 
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

### terrafrom apply -auto-approve
```
aws_instance.cluster[0]: Creating...
  ami:                          "" => "ami-0b69ea66ff7391e80"
  arn:                          "" => "<computed>"
  associate_public_ip_address:  "" => "<computed>"
  availability_zone:            "" => "us-east-1a"
  cpu_core_count:               "" => "<computed>"
  cpu_threads_per_core:         "" => "<computed>"
  ebs_block_device.#:           "" => "<computed>"
..
..
..
..
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

ec2_global_ips = [
    3.222.215.208,
    3.84.119.110,
    54.164.5.69
]
```


### terrafrom destroy -auto-approve

Output: 
Destroy complete! Resources: 3 destroyed.

### remote-exec and local-exec
Remote-exec -> Use for provisioning application on resource node once resource node is ready to server. (Bootsrap)
Local-exec -> Use for provisioning applications while resource is setting up. 

### Creating Multiple file to understand the code and stucture rather than using a single file.
### multi-instance.tf
This is the main file where I have mentioned the logic with using inbuilt functions of terrafrom.
```
resource "aws_key_pair" "deployer" {
  key_name = "${var.key_name}"
  public_key = "${file("/vagrant/mayank-user.pub")}"
}

########################################################################
### Creating 3 EC2 in multi Az which is listed in variable file. Here 
### 3 EC2 will be created with common security group.
########################################################################
resource "aws_instance" "cluster" {
  count = 3
  ami = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  availability_zone  = "${element(var.zones, count.index)}"
  key_name = "${var.key_name}"
  security_groups = ["All_traffic"]
  tags = {
    Name= "Test-VM-${count.index}"
	}

}
######################################################################
#### Null_resource --> The null_resource resource implements the standard resource lifecycle but takes no further action.
#### Trigger -- > The triggers argument allows specifying an arbitrary set of values that, when changed, will cause the resource to be replaced.
#### Element Function --> Will be using to element retrieves a single element from a list. Like index will start from 0.
######################################################################
resource "null_resource" "cluster" {
  count = 3
  triggers = {
    cluster_instance_ids = "${element(aws_instance.cluster.*.id,0)}"
  }
####################################################################
### File to be placed in provisioned EC2 
####################################################################
  provisioner "file" {
    source = "./httpd.sh"
    destination  = "/tmp/httpd.sh"
    connection {
        type     = "ssh"
        host     = "${element(aws_instance.cluster.*.public_ip, count.index + 1)}"
        user     = "${var.user}"
        private_key = "${file("/vagrant/mayank-user")}"
	timeout  = "2m"
    }
  }

############### Install necessary tools to run ansible on provisioned EC2
  provisioner "remote-exec" {
    inline = [
        "sudo amazon-linux-extras install docker -y",
        "sudo yum install python -y", 
	"sudo systemctl start docker",
        "sudo systemctl enable docker"]
    connection {
        type     = "ssh"
        host     = "${element(aws_instance.cluster.*.public_ip, count.index + 1)}"
        user     = "${var.user}"
        private_key = "${file("/vagrant/mayank-user")}"
	timeout	 = "2m"
    }
  }

############ Deploying code on provisioned EC2
  provisioner "local-exec" {
    command = "sleep 10s && ansible-playbook  -u ${var.user} -i '${element(aws_instance.cluster.*.public_ip, count.index + 1)},'  --private-key '${var.priv_key_path}' provision.yml"
  }
}

#################################################################
### Print the Public IPs 
################################################################

output "ec2_global_ips" {
  value = ["${aws_instance.cluster.*.public_ip}"]
}
```

### Feel free to fork and update in case you want to add more. I will add ELB soon with this. 
