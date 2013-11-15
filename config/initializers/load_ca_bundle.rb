# First of all get a ca-bundle.crt file (eg : from your open-source browser package)
require "openid/fetchers"
OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"
