variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "account_id"{
    type = string
    description = "The account ID from the learner lab found in the AWS details tab"
}
/*variable "common_tags" {
  description = "Common tags you want applied to all components."
}*/