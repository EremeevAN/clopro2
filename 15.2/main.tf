locals {
  network_name     = "develop"
  subnet_name1     = "public"
  subnet_name2     = "private"
  sg_nat_name      = "nat-instance-sg"
  vm_test_name     = "test-vm"
  vm_nat_name      = "nat"
  route_table_name = "nat-route"
  ssh_key_path = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcgt/AOnVvE8jIXBvqvW2o3J91v26dcRRxI/O03mEgf user@WIN-SQL1"
}

resource "yandex_vpc_network" "develop" {
  name = local.network_name
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  name = "public"
}

resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  route_table_id = yandex_vpc_route_table.nat-route.id
  name = "private"
}
resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = local.sg_nat_name
  network_id = yandex_vpc_network.develop.id

  egress {
    protocol       = "ANY"
    description    = "Всё"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}

resource "yandex_compute_image" "nat-instance-ubuntu" {
  source_family = "lamp"
}

resource "yandex_vpc_route_table" "nat-route" {
  name       = "nat-route"
  network_id = yandex_vpc_network.develop.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}




######## Задание №2 ############
#### Балансировщик Нагрузки и Сети#####
data "yandex_compute_instance_group" "dig_1" {
  instance_group_id = yandex_compute_instance_group.testing_ig.id
}
resource "yandex_lb_target_group" "my_tg" {
  name      = "my-target-group"
  region_id = "ru-central1"
#  target_group_id = yandex_lb_target_group.my_tg.id
  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = data.yandex_compute_instance_group.dig_1.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = data.yandex_compute_instance_group.dig_1.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = data.yandex_compute_instance_group.dig_1.instances[2].network_interface[0].ip_address
  }
}
resource "yandex_lb_network_load_balancer" "my_nlb" {
  name = "my-network-load-balancer"
  

   listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
   }
 
  attached_target_group {
    target_group_id = yandex_lb_target_group.my_tg.id

      healthcheck {
        name = "http"
        http_options {
          port = 80
          path = "/"
        }
      }
  }
}
