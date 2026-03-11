module "app_data_bucket" {
  source      = "./modules/secure_s3"
  bucket_name = "portfolio-app-data-bucket-12345"
}
