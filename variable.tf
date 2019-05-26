variable "general_setting" {
  type = "map"

  default = {
    vps_hostname = "azuki-vps"
    path_pub_key = "~/.ssh/id_rsa.pub"
    path_secret_key = "~/.ssh/id_rsa"
    auth_url = "https://identity.tyo2.conoha.io/v2.0"
  }
}

variable "conoha_config" {
  type = "map"

  default = {
    image_name = "vmi-ubuntu-18.04-amd64-20gb"
    image_id  = "41cca05d-7189-41c7-8b80-81c88ec509a2"
    flavor_id = "d92b02ce-9a4f-4544-8d7f-ae8380bc08e7"
  }
}

# For Environment variables
variable "C_TENANT_ID" {}
variable "C_USER_NAME" {}
variable "C_PASSWORD" {}
variable "VPS_MY_ROOT_PASSWD" {}
variable "VPS_MY_USERNAME" {}
variable "VPS_MY_PASSWD" {}
