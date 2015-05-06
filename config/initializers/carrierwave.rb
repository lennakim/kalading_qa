CarrierWave.configure do |config|
  config.storage             = Settings.pic_storage.to_sym
  config.qiniu_access_key    = Settings.qiniu.access_key
  config.qiniu_secret_key    = Settings.qiniu.secret_key
  config.qiniu_bucket        = Settings.qiniu.bucket
  config.qiniu_bucket_domain = Settings.qiniu.bucket_domain
  config.qiniu_bucket_private= true # default is false
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"
end
