# guac

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| AmiLookupLambdaArn | Arn of the ami-lookup-id lambda. See https://github.com/plus3it/lookup-ami-ids for more details. | `string` | n/a | yes |
| GuacDnsZoneId | Id of DNS zone for Guac Load Balancer DNS Record | `string` | n/a | yes |
| LdapDN | Distinguished Name (DN) of the LDAP directory.  E.g. DC=domain,DC=com | `string` | n/a | yes |
| LdapServer | Name of LDAP server Guacamole will authenticate against.  E.g. domain.com | `string` | n/a | yes |
| PrivateSubnetIds | List of Private Subnet IDs where the Guacamole instances will run | `list(string)` | n/a | yes |
| PublicSubnetIds | List of Public subnet IDs to attach to the Application Load Balancer | `list(string)` | n/a | yes |
| SslCertificateName | The name (for IAM) or identifier (for ACM) of the SSL certificate to associate with the ALB -- the cert must already exist in the service | `string` | n/a | yes |
| StackName | CloudFormation Stack Name.  Must be less than 10 characters | `string` | n/a | yes |
| VpcId | VPC to deploy instance(s) into | `string` | n/a | yes |
| AmiFilters | List of maps with additional ami search filters | <pre>list(object(<br>    {<br>      Name   = string,<br>      Values = list(string)<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "Name": "name",<br>    "Values": [<br>      "amzn-ami-hvm-2018.03.*-x86_64-gp2"<br>    ]<br>  }<br>]</pre> | no |
| AmiId | (Optional) AMI ID -- will supersede Lambda-based AMI lookup using AmiNameSearchString | `string` | `""` | no |
| AmiOwners | List of owners to filter ami search results against | `list(string)` | <pre>[<br>  "amazon"<br>]</pre> | no |
| BrandText | Text/Label to display branding for the Guac Login page | `string` | `"Remote Access"` | no |
| Capabilities | Required IAM capabilities | `list(string)` | <pre>[<br>  "CAPABILITY_AUTO_EXPAND",<br>  "CAPABILITY_NAMED_IAM",<br>  "CAPABILITY_IAM"<br>]</pre> | no |
| CloudWatchAgentUrl | (Optional) S3 URL to CloudWatch Agent installer. Example: s3://amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi | `string` | `"s3://amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm"` | no |
| DesiredCapacity | The number of instances the autoscale group will spin up initially | `string` | `"1"` | no |
| DisableRollback | Set to true to disable rollback of the stack if stack creation failed. Conflicts with OnFailure | `string` | `false` | no |
| DockerGuacamoleImage | Identifier for GUACAMOLE docker image. Used by docker pull to retrieve the guacamole image | `string` | `"guacamole/guacamole:1.2.0"` | no |
| DockerGuacdImage | Identifier for GUACD docker image. Used by docker pull to retrieve the guacd image | `string` | `"guacamole/guacd:1.2.0"` | no |
| ElbZones | Map of ELB Zones | `map(string)` | <pre>{<br>  "us-east-1": "Z35SXDOTRQ7X7K",<br>  "us-east-2": "Z3AADJGX6KTTL2",<br>  "us-west-1": "Z368ELLRRE2KJ0",<br>  "us-west-2": "Z1H1FL5HABSF5"<br>}</pre> | no |
| ForceUpdateToggle | A/B toggle that forces a change to a LaunchConfig property, triggering the AutoScale Update Policy | `string` | `"B"` | no |
| GuacBaseDN | The base of the DN for all Guacamole configurations. | `string` | `"CN=GuacConfigGroups"` | no |
| GuacPublicDnsHostname | Hostname of DNS record used to reach Guac Elb | `string` | `"guacamole"` | no |
| IamRoleArn | The ARN of an IAM role that AWS CloudFormation assumes to create the stack. If you don't specify a value, AWS CloudFormation uses the role that was previously associated with the stack. If no role is available, AWS CloudFormation uses a temporary session that is generated from your user credentials | `string` | `""` | no |
| InstanceType | Amazon EC2 instance type for the Remote Desktop Session Instance | `string` | `"c5.large"` | no |
| KeyPairName | Public/private key pairs allow you to securely connect to your instance after it launches | `string` | `""` | no |
| MaxCapacity | The maximum number of instances for the autoscale group | `string` | `"1"` | no |
| MinCapacity | The minimum number of instances for the autoscale group | `string` | `"0"` | no |
| NotificationArns | A list of SNS topic ARNs to publish stack related events | `list(string)` | `[]` | no |
| OnFailureAction | Action to be taken if stack creation fails. This must be one of: DO\_NOTHING, ROLLBACK, or DELETE. Conflicts with DisableRollback | `string` | `"ROLLBACK"` | no |
| PolicyBody | String containing the stack policy body. Conflicts with PolicyUrl | `string` | `""` | no |
| PolicyUrl | URL to a file containing the stack policy. Conflicts with PolicyBody | `string` | `""` | no |
| RemoteAccessScriptsUrl | URL prefix where the remote access scripts can be retrieved | `string` | `"https://raw.githubusercontent.com/plus3it/terraform-aws-remote-access/master"` | no |
| ScaleDownDesiredCapacity | (Optional) Desired number of instances during the Scale Down Scheduled Action; ignored if ScaleDownSchedule is unset | `string` | `"1"` | no |
| ScaleDownSchedule | (Optional) Scheduled Action in cron-format (UTC) to scale down the number of instances; ignored if empty or ScaleUpSchedule is unset (E.g. '0 0 * * *') | `string` | `""` | no |
| ScaleUpSchedule | (Optional) Scheduled Action in cron-format (UTC) to scale up to the Desired Capacity; ignored if empty or ScaleDownSchedule is unset (E.g. '0 10 * * Mon-Fri') | `string` | `""` | no |
| SslCertificateService | The service hosting the SSL certificate | `string` | `"ACM"` | no |
| StackCreateTimeout | The amount of time in minutes before the stack create fails | `string` | `"20"` | no |
| StackDeleteTimeout | The amount of time in minutes before the stack delete fails | `string` | `"20"` | no |
| StackTags | A map of tag keys/values to associate with this stack | `map(string)` | `{}` | no |
| StackUpdateTimeout | The amount of time in minutes before the stack update fails | `string` | `"20"` | no |
| URL1 | First custom URL/link to display on the Guac Login page | `string` | `"https://accounts.domain.com"` | no |
| URL2 | Second custom URL/link to display on the Guac Login page | `string` | `"https://redmine.domain.com"` | no |
| URLText1 | Text/Label to display for the First custom URL/link displayed on the Guac Login page | `string` | `"Account Services"` | no |
| URLText2 | Text/Label to display for the Second custom URL/link displayed on the Guac Login page | `string` | `"Redmine"` | no |
| UpdateSchedule | (Optional) Time interval between auto stack updates. Refer to the AWS documentation for valid input syntax: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `string` | `"cron(0 5 ? * Sun *)"` | no |

## Outputs

No output.

<!-- END TFDOCS -->
