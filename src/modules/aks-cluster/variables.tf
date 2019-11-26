variable "dns_suffix" {
  description = "DNS Suffix"
}

variable "location" {
  description = "azure location to deploy resources"
}

variable "cluster_name" {
  description = "AKS cluster name"
}

variable "resource_group_name" {
  description = "name of the resource group to deploy AKS cluster in"
}

variable "kubernetes_version" {
  description = "version of the kubernetes cluster"
}

variable "api_server_authorized_ip_ranges" {
  description = "ip ranges to lock down access to kubernetes api server"
  default     = "0.0.0.0/0"
}

# Node Pool config
variable "agent_pool_name" {
  description = "name for the agent pool profile"
  default     = "default"
}

variable "agent_pool_type" {
  description = "type of the agent pool (AvailabilitySet and VirtualMachineScaleSets)"
  default     = "AvailabilitySet"
}

variable "node_count" {
  description = "number of nodes to deploy"
}

variable "vm_size" {
  description = "size/type of VM to use for nodes"
}

variable "os_type" {
  description = "type of OS to run on nodes"
}

variable "os_disk_size_gb" {
  description = "size of the OS disk to attach to the nodes"
}

variable "vnet_subnet_id" {
  description = "vnet id where the nodes will be deployed"
}

variable "max_pods" {
  description = "maximum number of pods that can run on a single node"
}

#Network Profile config
variable "network_plugin" {
  description = "network plugin for kubenretes network overlay (azure or calico)"
  default     = "azure"
}

variable "service_cidr" {
  description = "kubernetes internal service cidr range"
  default     = "10.0.0.0/16"
}

# Cluster identity SP config
variable "client_id" {
  description = "azure service principal used as the aks nodes identity for managing cloud resources"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "client_secret" {
  description = "azure service principal key for node identity"
  default     = "00000000000000000000000000000000"
}

variable "diagnostics_workspace_id" {
  description = "log analytics workspace id for cluster audit"
}

# for tagging
locals {
  common_tags = {
    Environment = var.resource_group_name
  }
}

