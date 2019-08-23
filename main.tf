variable "path" {}
variable "kubeconfig" {}
variable "variables" {
  default = {}
}

resource "null_resource" "default" {
  triggers = {
    content = file(var.path)
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kubeconfig
    }
    command = "echo \"${templatefile(var.path, var.variables)}\" | kubectl apply -f -"
  }

  provisioner "local-exec" {
    when = "destroy"
    environment = {
      KUBECONFIG = var.kubeconfig
    }
    command    = "kubectl delete -f ${var.path}"
    on_failure = "continue"
  }
}
