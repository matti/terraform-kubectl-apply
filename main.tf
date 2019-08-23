variable "path" {}
variable "kubeconfig" {}

resource "null_resource" "default" {
  triggers = {
    content = file(var.path)
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kubeconfig
    }
    command = "kubectl apply -f ${var.path}"
  }

  provisioner "local-exec" {
    when = "destroy"
    environment = {
      KUBECONFIG = var.kubeconfig
    }
    command = "kubectl delete -f ${var.path}"
  }
}
