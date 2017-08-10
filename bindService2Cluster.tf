data "ibm_service_plan" "service_plan" {
  service = "cloudantNoSQLDB"
  plan    = "Lite"
}

resource "ibm_service_instance" "service" {
  name       = "CloudantDB4Cluster"
  space_guid = "${data.ibm_space.space.id}"
  service    = "${data.ibm_service_plan.service_plan.service}"
  plan       = "${data.ibm_service_plan.service_plan.plan}"
}

resource "ibm_service_key" "serviceKey" {
  name                  = "CloudantDB4ClusterTestKey"
  service_instance_guid = "${ibm_service_instance.service.id}"
}


resource "ibm_container_bind_service" "clusterbind" {
  org_guid     = "${data.ibm_org.orginst.id}"
  space_guid   = "${data.ibm_space.space.id}"
  account_guid = "${data.ibm_account.acc.id}"
  depends_on               = ["ibm_service_key.serviceKey"]
  cluster_name_id          = "${ibm_container_cluster.testacc_cluster.name}"
  service_instance_space_guid = "${data.ibm_space.space.id}"
  service_instance_name_id = "${ibm_service_instance.service.id}"
  namespace_id             = "default"
}
