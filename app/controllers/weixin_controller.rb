class WeixinController < ApplicationController
  def verify
    if _check_signature
      render :text => params[:echostr]
    else
      render :status => 401,:text=>""
    end
  end


  def _check_signature
    signature = params[:signature]
    timestamp = params[:timestamp]
    nonce = params[:nonce]
    token = ENV["WEIXIN_TOKEN"]
    arr = [token, timestamp, nonce].sort
    str = Digest::SHA1.hexdigest(arr*"")
    str == signature
  end
end