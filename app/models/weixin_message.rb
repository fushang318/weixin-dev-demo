class WeixinMessage
  attr_reader :content, :to_user_name, :from_user_name
  def initialize(xml)
    @xml = xml
    @doc = Nokogiri::XML(xml)
    _parse
  end

  def _parse
    @to_user_name   = @doc.at_css("ToUserName").content.strip
    @from_user_name = @doc.at_css("FromUserName").content.strip
    @msg_type = @doc.at_css("MsgType").content.strip
    @content  = @doc.at_css("Content").content.strip
    @msg_id   = @doc.at_css("MsgId").content.strip
  end

  def is_text?
    @msg_type == "text"
  end

end