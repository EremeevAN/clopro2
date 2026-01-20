resource "yandex_storage_bucket" "sysop" {
  access_key    = var.bucket_access_key
  secret_key    = var.bucket_secret_key
  acl           = "private"
  bucket        = "sysop"
  force_destroy = "true"
  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "image-object" {
  access_key = var.bucket_access_key
  secret_key = var.bucket_secret_key
  acl        = "private"
  bucket     = "sysop"
  key        = "cat.jpg"
  source     = "C:/Users/user/Desktop/clopro/cat.jpg"
  depends_on = [
    yandex_storage_bucket.sysop,
  ]
}