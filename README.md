# tf-aws-instance
Launch Single EC2 instance with terraform code

Terrafrom AWS Provider configure
Different ways 
The AWS provider offers a flexible means of providing credentials for authentication. The following methods are supported, in this order, and explained below:
•	Static credentials – To simply add credential in file. It may be at risk  
i.e. Static credentials can be provided by adding an access_key and secret_key in-line in the AWS provider block:
Usage:
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

•	Environment variables
You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively. Note that setting your AWS credentials using either these (or legacy) environment variables will override the use of AWS_SHARED_CREDENTIALS_FILE and AWS_PROFILE. The AWS_DEFAULT_REGION and AWS_SESSION_TOKEN environment variables are also used, if applicable:
provider "aws" {}
Usage:
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
$ terraform plan

•	Shared credentials file
We can configured it via command line which will generate a file in your local with information. 
### aws configure
AWS Access Key ID [****************ble:]: XXXXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXXX
Default region name [provider "aws" {}]: ap-XXXX-X
Default output format [Usage:]:

To get output
### aws configure get aws_access_key_id
Once you are ready with credential then you can communicate with cloud provider AWS using terrafrom tool and it will do whatever you will write in code. 
Let’s preform this.
You will get an issue if you are running terrafrom first time. 
#####ISSUE #####
[07:32:10 root@vagrantbox:/vagrant/tf-aws-instance] # terraform plan
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

################################

Now run create below file to which will be acted as key/core object to AWS. Otherwise AWS would not be able to understand who is trying to talking to them.
I have used 2 files (Main and variable). Make sure you follow the same way which will keep you code clean and easy to understand for others. 
[07:40:10 root@vagrantbox:/vagrant/tf-aws-instance] # cat main.tf
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

Hope you are clear with above commands. I have declare the values in variable file. 

Once you run below command. You will get output like this. 
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

### terrafrom apply -auto-approve
Outputs:

ec2_global_ips = [
    3.83.128.76
]

### terrafrom destroy -auto-approve
