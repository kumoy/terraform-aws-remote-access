data "aws_cloudformation_stack" "rdsh" {
  name       = "${var.StackName}"
  depends_on = ["null_resource.push-changeset"]
}

# data "aws_elb" "rdsh" {
# name = "${data.aws_cloudformation_stack.rdsh.outputs["LoadBalancerName"]}"
# depends_on = ["data.aws_cloudformation_stack.rdsh"]
# }
data "aws_region" "current" {}

data "terraform_remote_state" "rdcb" {
  backend = "local"

  config {
    path = "${path.module}/../rdcb-runfirst/terraform.tfstate"
  }
}

data "terraform_remote_state" "rdgw" {
  backend = "local"

  config {
    path = "${path.module}/../rdgw-runsecond/terraform.tfstate"
  }
}

resource "null_resource" "push-changeset" {
  provisioner "local-exec" {
    command     = "${join(" ", local.create_changeset_command)}"
    working_dir = ".."
  }

  provisioner "local-exec" {
    command = "${join(" ", local.destroy_changeset_command)}"
    when    = "destroy"
  }
}

locals {
  create_changeset_command = [
    "aws cloudformation deploy --template",
    "cfn/ra_rdsh_autoscale_internal_lb.template.cfn.json",
    " --stack-name ${var.StackName}",
    " --s3-bucket ${var.S3Bucket}",
    " --parameter-overrides AmiId=${var.AmiId}",
    "\"AmiNameSearchString=${var.AmiNameSearchString}\"",
    "\"ConnectionBrokerFqdn=${data.terraform_remote_state.rdcb.rdcb_hostname}\"",
    "\"DesiredCapacity=${var.DesiredCapacity}\"",
    "\"DomainAccessUserGroup=${var.DomainAccessUserGroup}\"",
    "\"DomainDirectoryId=${var.DomainDirectoryId}\"",
    "\"DomainDnsName=${var.DomainDnsName}\"",
    "\"DomainNetbiosName=${var.DomainNetbiosName}\"",
    "\"DomainSvcAccount=${var.DomainSvcAccount}\"",
    "\"DomainSvcPassword=${var.DomainSvcPassword}\"",
    "\"ExtraSecurityGroupIds=${data.terraform_remote_state.rdcb.rdsh_sg_id}, ${var.ExtraSecurityGroupIds}\"",
    "\"ForceUpdateToggle=${var.ForceUpdateToggle}\"",
    "\"InstanceType=${var.InstanceType}\"",
    "\"KeyPairName=${var.KeyPairName}\"",
    "\"LdapContainerOU=${var.LdapContainerOU}\"",
    "\"MaxCapacity=${var.MaxCapacity}\"",
    "\"MinCapacity=${var.MinCapacity}\"",
    "\"RdpPrivateKeyPassword=${var.RdpPrivateKeyPassword}\"",
    "\"RdpPrivateKeyPfx=${var.RdpPrivateKeyPfx}\"",
    "\"RdpPrivateKeyS3Endpoint=${var.RdpPrivateKeyS3Endpoint}\"",
    "\"ScaleDownDesiredCapacity=${var.ScaleDownDesiredCapacity}\"",
    "\"ScaleDownSchedule=${var.ScaleDownSchedule}\"",
    "\"ScaleUpSchedule=${var.ScaleUpSchedule}\"",
    "\"SubnetIDs=${var.SubnetIDs}\"",
    "\"UserProfileDiskPath=\\\\\\\\${data.terraform_remote_state.rdcb.rdcb_hostname}\\\\${var.UserProfileDiskPath}\"",
    "\"VPC=${var.VpcId}\"",
    "\"CloudWatchAgentUrl=${var.CloudWatchAgentUrl}\"",
    "--capabilities CAPABILITY_IAM",
  ]

  check_stack_progress = [
    "aws cloudformation wait stack-create-complete --stack-name ${var.StackName}",
  ]

  destroy_changeset_command = [
    "aws cloudformation delete-stack --stack-name ${var.StackName}",
  ]
}

resource "aws_route53_record" "lb_dns" {
  zone_id = "${var.Private_Dnszone_Id}"
  name    = "${var.Dns_Name}"
  type    = "A"

  alias {
    name = "${data.aws_cloudformation_stack.rdsh.outputs["LoadBalancerDns"]}"
    zone_id                = "${var.nlb_zones["${data.aws_region.current.name}"]}"
    evaluate_target_health = true
  }
}