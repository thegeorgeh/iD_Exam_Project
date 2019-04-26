#Instances
#================================================================================#

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "${var.region}"
  network       = "${var.network}"
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}


resource "google_compute_address" "static" {
	name = "ipv4-address"
}

resource "google_compute_instance" "gameapp" {
	name = "${var.name}"
	machine_type = "${var.machine_type}"
	zone = "${var.zone}"
	tags = ["${var.name}"]
	
	metadata {
		sshKeys = "${var.ssh_user}:${file("${var.public_key}")}"
  	}	
	
	boot_disk {
		initialize_params {
			image = "${lookup(var.images, var.image)}"
		}
	}
	
	network_interface {
		network = "${var.network}"
		access_config {
			nat_ip = "${google_compute_address.static.address}"
		}
	}
	
	provisioner "file"{
		source = "${var.file_sources[0]}"
		destination ="${var.file_destinations[0]}"
	}
	
	provisioner "file"{
		source = "${var.file_sources[1]}"
		destination ="${var.file_destinations[1]}"
	}
	
	provisioner "remote-exec"{
	inline = [
		"sudo yum install update",
		]
	}
	 
	connection = {
		type = "ssh"
		user = "${var.ssh_user}"
		private_key = "${file("${var.private_key}")}"
	}
}


#Firewall rules
#================================================================================#

resource "google_compute_firewall" "default" {
	name    = "test-firewall"
	network = "default"
	target_tags = ["${var.name}"]
	allow {
		protocol = "tcp"
		ports    = ["80", "8080"]
	}

	source_ranges = ["0.0.0.0/0"]
}


#Null resources
#================================================================================#

resource "null_resource" "install_gameapp"{
	depends_on = ["google_compute_instance.gameapp"]	
	connection = {
		host = "${google_compute_address.static.address}"
		type = "ssh"
		user = "${var.ssh_user}"
		private_key = "${file("${var.private_key}")}"
	}
	
	provisioner "remote-exec"{
		inline = [
			"sudo yum install update",
			"sudo yum install dos2unix",
			"dos2unix /tmp/script.sh",
			"chmod +x /tmp/script.sh",
			"sudo /tmp/script.sh",
		]
	}
}

resource "null_resource" "configuration"{
	depends_on = ["null_resource.install_gameapp"]		
	connection = {
		host = "${google_compute_address.static.address}"
		type = "ssh"
		user =  "${var.ssh_user}"
		private_key = "${file("${var.private_key}")}"
	}
	
	provisioner "remote-exec"{
		inline = [
			"dos2unix /tmp/script2.sh",
			"chmod +x /tmp/script2.sh",
			"sudo /tmp/script2.sh",
		]
	}
	
	provisioner "local-exec"{
		command = "start chrome ${google_compute_address.static.address}:8080"
	}
}

output "public-ip"{
	value = "${google_compute_address.static.address}"
}