output "vpc" {
  value = module.vpc.vpc
}

output "s3" {
  value = module.s3.s3_bucket
}
