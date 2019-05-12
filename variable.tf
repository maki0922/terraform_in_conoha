variable "general_setting" {
  type = "map"

  default = {
    path_pub_key = "~/.ssh/id_rsa.pub"
    path_secret_key = "~/.ssh/id_rsa"
    auth_url = "https://identity.tyo2.conoha.io/v2.0"
  }
}

variable "conoha_config" {
  type = "map"

  default = {
    image_id  = "1ae808e4-f4ee-4ee6-adfc-0ba8c2bf67f3"
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
