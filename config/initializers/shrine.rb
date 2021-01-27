require "shrine"
require 'shrine/storage/file_system'
require 'shrine/storage/s3'  # ここを追記
require 'shrine/plugins/backgrounding'
require 'shrine/plugins/data_uri'

# 使用するプラグインの宣言
Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file 
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :backgrounding
Shrine.plugin :refresh_metadata # allow re-extracting metadata 
Shrine.plugin :uppy_s3_multipart             # uppy s3 multipart support
Shrine.plugin :upload_endpoint
Shrine.plugin :presign_endpoint, presign_options: -> (request) { 
  # Uppy will send the "filename" and "type" query parameters 
  filename = request.params["filename"]
  type     = request.params["type"]
 
  { 
    content_disposition:    ContentDisposition.inline(filename), # set download filename 
    content_type:           type,                                # set content type (required if using DigitalOcean Spaces) 
    content_length_range:   0..(300*1024*1024),                   # limit upload size to 300 MB 
  }
}

# アップロードするディレクトリの指定
# ここを追記
#if Rails.env.production? || Rails.env.staging?
s3_options = {
  access_key_id:     ENV['S3_ACCESS_KEY'],
  secret_access_key: ENV['S3_SECRET_KEY'],
  region:            ENV['S3_REGION'],
  bucket:            ENV['S3_BUCKET']}
#s3_options = s3_options.merge(credentials: Aws::InstanceProfileCredentials.new)
Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(prefix: 'store', **s3_options)}
#else
#  # この部分は元々記述していた
#  Shrine.storages = {
#      cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
#      store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')}
#end