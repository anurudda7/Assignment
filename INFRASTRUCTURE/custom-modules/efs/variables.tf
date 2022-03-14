variable "token" {
    type = string
    default = "my_token"
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}




variable "subnet_id" {
        type = string
  
}

