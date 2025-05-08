variable "azure_client_id" {
    type = string
    default = "bdda306d-63e3-4414-bf24-2db8ed2896dc"
}

variable "azure_subscription_id" {
    type = string
    default = "df7cf24b-44d7-4e01-a148-088e158e584f"
}

variable "azure_client_secret" {
    type = string
    default = "MA58Q~GJiB4v6yml2nC1-yhk5X44dI_fvbIohbfS"
}

variable "azure_tenant_id" {
    type = string
    default = "1374cc75-6a80-4cee-b62f-6b96f26d0416"
}

variable "azure_location" {
    type = string
    default = "eastus"
}

variable "azure_resource_group" {
    type = string
    default = "actividad1"
}

variable "azure_ssh_username" {
    type = string
    default = "ubuntu"
}

variable "azure_vm_size" {
    type = string
    default = "Standard_B1s"
}

variable "azure_image_publisher" {
    type = string
    default = "Debian"
}

variable "azure_image_offer" {
    type = string
    default = "debian-12"
}

variable "azure_image_sku" {
    type = string
    default = "12"
}

variable "azure_vm_name" {
    type = string
    default = "GeneratedVM"
}