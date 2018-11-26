# Disable sprockets server: CVE-2018-3760
if Rails.env.production?
    CfiOauthProvider::Application.config.assets.compile = false
end
