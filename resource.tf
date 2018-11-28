resource "google_compute_instance" "default" {
	name = "jenkins-${count.index+1}"
	machine_type = "n1-standard-1"
	zone = "europe-west2-c"
	tags = ["jenkins"]
	count = 2
	boot_disk {
		initialize_params {
			image = "centos-7"
		}
	}
	network_interface {
		network = "default"
		access_config {
			// Ephemeral IP
		}
	}
	metadata {
    	sshKeys = "terraform:${file("~/.ssh/id_rsa.pub")}"
  }	
	connection = {
		type = "ssh"
		user = "terraform"
		private_key = "${file("~/.ssh/id_rsa")}"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum install -y java wget"
		]
	}
	provisioner "remote-exec" {
		script = "jenkins_centos7"
	}
	provisioner "remote-exec" {
		script = "script_1"
	}
}
