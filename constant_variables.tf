#Provider variables
#=============================================

variable "terraform_keys" {
    default = ".json"
}

variable "project_id" {
    default = "centos-238514"
}

variable "region" {
    default = "europe-west2"
}

#Resource variables
#===============================================

variable "name" {
    default = "terra"
}

variable "machine_type" {
	default = "n1-standard-1"
}

variable "zone" {
	default = "europe-west2-c"
}

variable "images" {
    default = {
        "centos" = "centos-7"
    }
}

variable "image" {
    default = "centos"
}

variable "network" {
	default = "default"
}

variable "disk" {
    default = "gameapp-home"
}

variable "size" {
    default = "12"
}

#Provisioner variables
#=======================================================#

variable "provisioner_1"{
	default = "file"
}

variable "provisioner_2"{
	default = "remote-exec"
}

variable "command_1"{
	default = "chmod +x /tmp/script.sh"
}

variable "command_2"{
	default = "/tmp/script.sh"
}

variable "file_sources"{
	default = ["script.sh", "script2.sh"]
}

variable "file_destinations"{
	default = ["/tmp/script.sh", "/tmp/script2.sh"]
}

#Connection variables
#===================================================

variable "ssh_user" {
    default = "georgeheimsath"
}

variable "public_key" {
    default = ".ssh/public.pub"
}

variable "private_key" {
    default = ".ssh/private"
}
