terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_replication_factor_issues_in_cassandra" {
  source    = "./modules/high_replication_factor_issues_in_cassandra"

  providers = {
    shoreline = shoreline
  }
}