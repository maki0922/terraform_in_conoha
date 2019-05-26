provider "openstack" {
  user_name   = "${var.C_USER_NAME}"
  password    = "${var.C_PASSWORD}"
  tenant_id = "${var.C_TENANT_ID}"
  auth_url    = "${lookup(var.general_setting, "auth_url")}"
}

data "template_file" "user_data" {
  template = "${file("user_data.tpl")}"
  vars = {
    out_rootpassword = "${var.VPS_MY_ROOT_PASSWD}"
    out_username = "${var.VPS_MY_USERNAME}"
    out_password = "${var.VPS_MY_PASSWD}"
    out_hostname = "${lookup(var.general_setting, "vps_hostname")}"
    out_id_rsa = "${file(lookup(var.general_setting, "path_secret_key"))}"
    out_pub_key = "${file(lookup(var.general_setting, "path_pub_key"))}"
  }
}

resource "openstack_networking_secgroup_v2" "azuki_sec_group" {
  name        = "azuki_sec_group"
  delete_default_rules = true
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "azuki_secgroup_rule01" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 443
  security_group_id = "${openstack_networking_secgroup_v2.azuki_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "azuki_secgroup_rule02" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 443
  security_group_id = "${openstack_networking_secgroup_v2.azuki_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "azuki_secgroup_rule03" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 443
  security_group_id = "${openstack_networking_secgroup_v2.azuki_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "azuki_secgroup_rule04" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1
  port_range_max    = 443
  security_group_id = "${openstack_networking_secgroup_v2.azuki_sec_group.id}"
}

resource "openstack_compute_instance_v2" "deploy_basic_instance" {
  name        = "azuki-vps"
  #image_id    = "${lookup(var.conoha_config, "image_id")}"
  image_name    = "${lookup(var.conoha_config, "image_name")}"
  flavor_id = "${lookup(var.conoha_config, "flavor_id")}"
  key_pair    = "terraform-keypair"

  security_groups = [
    "azuki_sec_group",
  ]

  user_data = "${data.template_file.user_data.rendered}"

  metadata {
    instance_name_tag = "azuki-vps"
  }
}
