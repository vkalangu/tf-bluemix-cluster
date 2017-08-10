provider "ibm" {
  region = "eu-de"
  //softlayer_account_number = "1204953"
  //softlayer_account_number = "1186049"
  bluemix_api_key = "u_1FjNyi-5v8d8CBrOLSkIpqlIZpONIpH9R6KS1qgGCm"
}

data "ibm_org" "orginst" {
  org = "vkalangu@in.ibm.com"
}

data "ibm_account" "acc" {
  org_guid = "${data.ibm_org.orginst.id}"
}

data "ibm_space" "space" {
  org   = "${data.ibm_org.orginst.org}"
  space = "devGermany"
}

resource "ibm_container_cluster" "testacc_cluster" {
  org_guid     = "${data.ibm_org.orginst.id}"
  space_guid   = "${data.ibm_space.space.id}"
  account_guid = "${data.ibm_account.acc.id}"
  name         = "vjtftestJun22_1"

  datacenter      = "ams03"
  //datacenter = "mex01"
  //no_subnet = "true"

  workers = [{
    name   = "vjtftestJun22_1-w1"
    action = "add"
  },
    {
      name   = "vjtftestJun22_1-w2"
      action = "add"
    },
    {
      name   = "vjtftestJun22_1-w3"
      action = "add"
    },
  ]

  webhook= {
  				level="Normal",
  				type="slack",
  				url="https://hooks.slack.com/services/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"
  			}

  machine_type = "u1c.2x4"
  public_vlan_id = 1764435
  private_vlan_id = 1764491
  
  //subnet_id=["1258403","1406775"]
}

/*data "ibm_container_cluster" "testacc_cluster" {
  org_guid     = "${data.ibm_org.orginst.id}"
  space_guid   = "${data.ibm_space.space.id}"
  account_guid = "${data.ibm_account.acc.id}"
  cluster_name_id = "${ibm_container_cluster.testacc_cluster.name}"
}

output "cluster_name" {
  value = "${data.ibm_container_cluster.testacc_cluster.cluster_name_id}"
}

output "cluster_id" {
  value = "${data.ibm_container_cluster.testacc_cluster.id}"
}

output "cluster_worker_count" {
  value = "${data.ibm_container_cluster.testacc_cluster.worker_count}"
}
*/

data "ibm_container_cluster_config" "tf-vg-ds-acc-test" {
  org_guid     = "${data.ibm_org.orginst.id}"
  space_guid   = "${data.ibm_space.space.id}"
  account_guid = "${data.ibm_account.acc.id}"
  cluster_name_id     = "${ibm_container_cluster.testacc_cluster.name}"
  config_dir = "/Users/vijayrajk/mainwork/terraform/cluster"
  //download = false
  //admin=true
}


output "cluster_config_path" {
  value = "${data.ibm_container_cluster_config.tf-vg-ds-acc-test.config_file_path}"
}

