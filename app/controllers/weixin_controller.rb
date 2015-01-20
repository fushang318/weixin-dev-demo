class WeixinController < ApplicationController
  def verify_get
    if _check_signature
      render :text => params[:echostr]
    else
      render :status => 401,:text=>""
    end
  end

  def verify_post
    if _check_signature
      xml = request.body.read
      wmp = WeixinMessageParse.new(xml)
      message = wmp.message
      str = "您的ID是 #{message.to_user_name}\n"
      result_content = case message.class
      when WeixinMessageParse::TextMessage
        "#{str}您输入的是:#{message.content}"
      when WeixinMessageParse::VoiceMessage
        "#{str}您的语音信息是:#{message.recognition}"
      when WeixinMessageParse::SubscribeEventMessage
        "欢迎关注fushang318\n#{str}您可以输入文本或录音"
      end
      res = %`
      <xml>
        <ToUserName><![CDATA[#{message.from_user_name}]]></ToUserName>
        <FromUserName><![CDATA[#{message.to_user_name}]]></FromUserName>
        <CreateTime>#{Time.now.to_i}</CreateTime>
        <MsgType><![CDATA[text]]></MsgType>
        <Content><![CDATA[#{result_content}]]></Content>
      </xml>
      `
      render :text => res
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