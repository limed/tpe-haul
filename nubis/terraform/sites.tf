module "tpe" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name     = "tpe"
  haul_git_repo = "https://github.com/limed/tpe-haul"
}
