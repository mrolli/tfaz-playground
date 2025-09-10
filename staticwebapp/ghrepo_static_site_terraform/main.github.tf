resource "github_actions_secret" "api_token" {
  repository      = data.github_repository.staticwebapp.name
  secret_name     = local.api_token_var
  plaintext_value = module.staticweapp.api_key
}

resource "github_repository_file" "workflow_file" {
  repository = data.github_repository.staticwebapp.name
  branch     = var.repository_branch
  file       = ".github/workflows/azure-static-web-apps.yml"
  content = templatefile("./azure-static-web-apps.tpl",
    {
      app_location    = var.app_config.app_location
      api_location    = var.app_config.api_location
      output_location = var.app_config.output_location
      api_token_var   = local.api_token_var
    }
  )
  commit_message      = "Update Azure deployment workflow (by Terraform)"
  overwrite_on_create = true

  depends_on = [github_actions_secret.api_token]
}
