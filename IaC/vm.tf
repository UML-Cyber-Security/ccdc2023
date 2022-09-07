data "xenorchestra_pool" "pool" {
  name_label = "cybersec-ccdc2023"
}

data "xenorchestra_template" "vm_template" {
  name_label = "TEMPLATE_NAME"
}

data "xenorchestra_sr" "sr" {
  name_label = "Local storage"
  pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "network" {
  name_label = "Pool-wide network associated with eth0"
  pool_id = data.xenorchestra_pool.pool.id
}