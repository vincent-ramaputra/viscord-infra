terraform {
  required_version = "1.15.9"

  cloud {
    organization = "vincent_solo_team"

    workspaces {
      name = "aws-dev"
    }
  }
}