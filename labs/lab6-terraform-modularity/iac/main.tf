# (Defining the module usage)
module "app_data_bucket" {
  source      = "../../modules/secure_s3" # Relative path adjustment
  bucket_name = "portfolio-app-data-bucket-12345"
}
