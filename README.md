# converge-elk

A converge sample that sets up a docker-based ELK stack.

Filebeat is used instead of Logstash for the log collection component.

## Usage

After running `vagrant up`, you should have a working Kibana instance backed by Elasticsearch. Filebeat is installed on the Vagrant host and is configured to send logs to Elasticsearch.
