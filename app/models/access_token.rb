class AccessToken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :access_token, type: String
  field :expires_in, type: Integer

  def self.refresh!
    appid      = ENV['WEIXIN_APPID']
    app_secret = ENV['WEIXIN_APP_SECRET']
    weixin = Weixin.new(appid, app_secret)
    json = weixin.get_access_token
    access_token = json["access_token"]
    expires_in = json["expires_in"]
    if !access_token.blank? && !expires_in.blank?
      at = AccessToken.first || AccessToken.create
      at.access_token = access_token
      at.expires_in = expires_in
      at.save
    end
  end

  def self.is_expired?
    return true if AccessToken.first.blank?
    at = AccessToken.first
    expires_at = at.updated_at.to_i + at.expires_in
    # 提前十秒过期，为了平滑过渡
    expires_at - 10 < Time.now.to_i
  end

  def self.value
    if self.is_expired?
      self.refresh!
    end
    self.first.access_token
  end
end