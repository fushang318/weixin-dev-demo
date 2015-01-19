class Weixin
  class Uri
    def self.get_access_token(appid, app_secret)
      "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appid}&secret=#{app_secret}"
    end

    def self.get_user_info(access_token, openid)
      "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
    end
  end

  def initialize(appid, app_secret)
    @appid = appid
    @app_secret = app_secret
  end

  def get_access_token
    uri = URI(Weixin::Uri.get_access_token(@appid, @app_secret))
    res = Net::HTTP.get(uri)
    JSON.parse(res)
  end

  def self.get_user_info(access_token, openid)
    uri = URI(Weixin::Uri.get_user_info(access_token, openid))
    res = Net::HTTP.get(uri)
    JSON.parse(res)
  end

end