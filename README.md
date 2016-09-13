# converge-elk

A converge sample that sets up a docker-based ELK stack.

Filebeat is used instead of Logstash for the log collection component.

## Usage

### Vagrant

In the Vagrantfile, change the file provisioner source to point to a linux/amd64 version of the converge binary.

After running `vagrant up`, you should have a working Kibana instance backed by Elasticsearch. Filebeat is installed on the Vagrant host and is configured to send logs to Elasticsearch.

### Terraform (AWS)

You must have a version of https://github.com/ChrisAubuchon/terraform-provisioner-converge built and configured as a plugin for terraform:

```shell
$ cat ~/.terraformrc
provisioners {
  converge = "/path/to/terraform-provisioner-converge"
}%
```

You must have also set [AWS credentials](https://www.terraform.io/docs/providers/aws/index.html) in your environment. Then you can run:

```
terraform apply
```

After provisioning completes, you should be able to access the Kibana interface at:

```shell
echo "http://$(terraform output ip):5601/"
```

#### Warning

When deploying via Terraform, Kibana will be publicly accessible on port 5601 without authentication. You can adjust the security group in `main.tf` to change this behavior.
