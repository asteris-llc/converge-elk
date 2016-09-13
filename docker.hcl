param "docker-package" {
  default = "docker-engine"
}

param "docker-service" {
  default = "docker"
}

param "docker-group" {
  default = "docker"
}

param "user-name" {
  default = "vagrant"
}

file.content "docker-repo" {
  destination = "/etc/yum.repos.d/docker.repo"
  content = <<EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
}

task "docker-install" {
  check = "yum list installed {{param `docker-package`}}"
  apply = "yum makecache; yum install -y {{param `docker-package`}}"
  depends = ["file.content.docker-repo"]
}

task "docker-user-group" {
  check = "groups {{param `user-name`}} | grep -i {{param `docker-group`}}"
  apply = "usermod -aG {{param `docker-group`}} {{param `user-name`}}"
  depends = ["task.docker-install"]
}

task "docker-enable" {
  check = "systemctl is-enabled {{param `docker-service`}}"
  apply = "systemctl enable {{param `docker-service`}}"
  depends = ["task.docker-user-group"]
}

task "docker-start" {
  check = "systemctl is-active {{param `docker-service`}}"
  apply = "systemctl start {{param `docker-service`}}"
  depends = ["task.docker-enable"]
}
