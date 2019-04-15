resource "vsphere_virtual_machine" "vm" {
  count = "${var.instances}"
  name  = "${var.vmname_prefix}${var.vmname}${count.index+1}"

  resource_pool_id = "${data.vsphere_compute_cluster.compute_cluster.resource_pool_id}"
  folder           = "${vsphere_folder.folder.path}"
  
  num_cpus = "${var.cpu_number}" 
  memory   = "${var.ram_size}"
  guest_id  = "ubuntu64Guest"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"

  }

  disk {
    label            = "disk1"
    size             = "${var.data_disk_size_gb}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.vmname}"
        domain    = "${var.vmdomain}"
      }

      network_interface {
        ipv4_address = "${element(var.ipaddress, 0)}"
        ipv4_netmask = "${var.ipv4submask}"
      }

      dns_server_list = ["${var.vmdns}"]
      ipv4_gateway    = "${var.vmgateway}"
    }
  }
  //custom_attributes = "${map(vsphere_custom_attribute.attribute.id, "${var.attributeValue}")}"
}
