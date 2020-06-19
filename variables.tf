variable "subscription_id"{
    type = string
}
variable "client_id"{
    type = string
}
variable "tenant_id"{
    type = string
}

variable "location"{
    type = string
    description = "Enter location of resource group"
}

variable "address_space"{
    type = string
    description = "Enter address space for Virtual network"
    default = "10.0.0.0/16"
}
variable "address_prefix"{
    type = string
    description = "Enter address prefix for subnet"
    default = "10.0.0.0/24"
}

variable "primary_private_ip_address" {
    type = string
    description = "Enter primary private nat ip address"
    default = "10.0.0.7"
}

variable "secondary_private_ip_address" {
    type = string
    description = "Enter secondary private nat ip address"
    default = "10.0.0.8"
}
