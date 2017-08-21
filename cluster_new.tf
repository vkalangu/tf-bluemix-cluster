provider "ibm" {
  region = "eu-de"
  bluemix_api_key = "${var.bluemix_api_key}"
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

  workers = [{
    name   = "vjtftestJun22_1-w1"
  },
    {
      name   = "vjtftestJun22_1-w2"
    },
    {
      name   = "vjtftestJun22_1-w3"
    },
    {
      name   = "vjtftestJun22_1-w4"
    },
  ]

  webhook= {
  				level="Normal",
  				type="slack",
  				url="https://hooks.slack.com/services/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"
  			}

  machine_type = "u1c.2x4"
  public_vlan_id = "${var.public_vlan_id}"
  private_vlan_id = "${var.private_vlan_id}"
  
  
}


data "ibm_container_cluster_config" "tf-vg-ds-acc-test" {
  org_guid     = "${data.ibm_org.orginst.id}"
  space_guid   = "${data.ibm_space.space.id}"
  account_guid = "${data.ibm_account.acc.id}"
  cluster_name_id     = "${ibm_container_cluster.testacc_cluster.name}"
  config_dir = "${var.config_dir}"
}


output "cluster_config_path" {
  value = "${data.ibm_container_cluster_config.tf-vg-ds-acc-test.config_file_path}"
}

