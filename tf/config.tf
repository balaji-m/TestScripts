terraform {
  cloud {
    organization = "MyFirstOrg-BalajiM"

    workspaces {
      name = "MyAPIWorkspace"
    }
  }
}
