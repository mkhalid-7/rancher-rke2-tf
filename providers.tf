terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "7.0.0"
    }
  }
}

provider "rancher2" {
  api_url = var.rancher_url
  token_key = var.bearer_token
  insecure = true
  # insecure = false
}

