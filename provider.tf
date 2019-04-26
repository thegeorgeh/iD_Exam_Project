provider "google" {
    credentials = "${file("${var.terraform_keys}")}"
    project = "${var.project_id}"
    region = "${var.region}"
}