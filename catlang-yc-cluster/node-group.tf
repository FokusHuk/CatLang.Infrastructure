resource "yandex_kubernetes_node_group" "catlang-ng" {
  cluster_id  = "${yandex_kubernetes_cluster.catlang-cluster-a.id}"
  name        = "catlang-ng"
  description = "catlang node group"
  version     = local.k8s_version

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.catlang-subnet.id}"]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    container_runtime {
      type = "docker"
    }
  }

  scale_policy {
    auto_scale {
      min     = 1
      max     = 3
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}