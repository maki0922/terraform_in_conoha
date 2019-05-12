Deployment My instance in conoha by terraform
=====

# Overview

## Description
conoha VPSに対してinstanceを1台生成するterraformファイル。
自端末の鍵情報の配置と登録をすることによって面倒ごとを予め解消しておく。

## Deployment Function
実行することにより、以下のinstanceを生成する。

#### 1. UserSetting
一般ユーザの生成及び端末側のSSH鍵を交換する事に
よってパスワード無しでログイン出来る。

#### 2. user_data送付
user_dataを送信することによって、Deplyoment時に設定が行える

# Installation
以下の条件で動作確認を行なっている。  

## Requirement
- Mac Book (10.14.4)
- terraform(v0.11.13)

## Install
- `git clone https://github.com/maki0922/terraform_in_conoha`
- `cd terraform_in_conoha` 
- `edit .conoha.rc`
- `edit variable.tf`
- `terraform init`
- `terraform apply`

# Fast Start
1. Set [Configration.](#Configuration)
2. Run terraform (init => apply)

# Configuration
設定ファイルは以下の2ファイル存在する。
`.conoha.rc`ファイルは個人情報が入るため、
シンボリックリンク等にすると良いだろう。

## .conoha.rc file
API送信アカウント/パスワード等、個人情報を管理する。
また、送信したuser_data実行時に作成/設定するユーザ情報を管理する。

```
#Conoha API infomation.
export TF_VAR_C_TENANT_ID=< テナントID >
export TF_VAR_C_USER_NAME=< conohaのAPIアカウント >
export TF_VAR_C_PASSWORD=< conohaのAPIアカウントのパスワード >

# VPS user infomation after create instance.
export TF_VAR_VPS_MY_ROOT_PASSWD=< instanceのROOTパスワード >
export TF_VAR_VPS_MY_USERNAME=< instanceの一般ユーザのアカウント >
export TF_VAR_VPS_MY_PASSWD=< instanceの一般ユーザのパスワード >
```

## variable.tf file
主に公開可能な情報を管理する。

デフォルト設定では以下のinstanceを生成する。
- Image : Ubuntu18.04(64bit)の公開されているテンプレートイメージ
- Flavor(プラン) : 1CPU 512MB

またinstanceに配置する秘密鍵と登録する公開鍵のファイルのパスを記述する。
```
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
```
