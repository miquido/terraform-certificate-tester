# certificate-tester <a href="https://miquido.com"><img align="right" src="https://cdn.miquido.dev/miquido-logo.png" width="150" /></a>

AWS Lambda SSL certificate expiry checker with SNS alerts

## Development

```bash
make init   # run once after cloning
make readme # regenerate README.md
make lint   # lint terraform code
```

## Usage

```hcl
module "certificate_tester" {
  source = "git@gitlab.miquido.com:miquido/terraform/certificate-tester.git"

  project     = "myproject"
  environment = "production"
  domain      = "example.com"

  sns_topic_arn = "arn:aws:sns:eu-west-1:123456789012:alerts"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_event_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.cert-tester-lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cert-tester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cert-tester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.cert-tester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain to check certificate validity | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | How long should logs be retained | `number` | `30` | no |
| <a name="input_project"></a> [project](#input\_project) | Account/Project Name | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). | `string` | `"cron(0 0 * * ? *)"` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

[MIT](LICENSE)
