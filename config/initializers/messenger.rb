Messenger.configure do |config|
  config.verify_token      = Digest::SHA1.hexdigest(Settings.token) #will be used in webhook verifiction
  config.page_access_token = Settings.fb_page_access_token
end