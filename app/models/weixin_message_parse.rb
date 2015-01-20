class WeixinMessageParse
  attr_reader :type
  def initialize(xml)
    @xml = xml
    @doc = Nokogiri::XML(xml)
    _parse
  end

  def _parse
    @msg_type = @doc.at_css("MsgType").content.strip
    if @msg_type == MsgType::EVENT
      @event = @doc.at_css("Event").content.strip
    end
  end

  def message
    # 文本信息
    if @msg_type == MsgType::TEXT
      return TextMessage.new(@xml)
    end
    # 语音信息
    if @msg_type == MsgType::VOICE
      return VoiceMessage.new(@xml)
    end
    # 关注事件
    if @msg_type == MsgType::EVENT && @event == EventType::SUBSCRIBE
      return SubscribeEventMessage.new(@xml)
    end
    return nil
  end

  class MsgType
    TEXT  = 'text'
    VOICE = 'voice'
    EVENT = 'event'
  end
  class EventType
    SUBSCRIBE = 'subscribe'
  end

  class TextMessage
    attr_reader :msg_type, :content, :to_user_name, :from_user_name
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
  end

  class VoiceMessage
    attr_reader :msg_type, :recognition, :to_user_name, :from_user_name
    def initialize(xml)
      @xml = xml
      @doc = Nokogiri::XML(xml)
      _parse
    end

    def _parse
      @to_user_name   = @doc.at_css("ToUserName").content.strip
      @from_user_name = @doc.at_css("FromUserName").content.strip
      @msg_type     = @doc.at_css("MsgType").content.strip
      @recognition  = @doc.at_css("Recognition").content.strip
      @msg_id       = @doc.at_css("MsgId").content.strip
    end
  end

  class SubscribeEventMessage
    attr_reader :msg_type, :event, :to_user_name, :from_user_name
    def initialize(xml)
      @xml = xml
      @doc = Nokogiri::XML(xml)
      _parse
    end

    def _parse
      @to_user_name   = @doc.at_css("ToUserName").content.strip
      @from_user_name = @doc.at_css("FromUserName").content.strip
      @msg_type = @doc.at_css("MsgType").content.strip
      @event    = @doc.at_css("Event").content.strip

      ek_ele = @doc.at_css("EventKey")
      @event_key = ek_ele.blank? ? "" : ek_ele.content.strip

      ticket_ele = @doc.at_css("Ticket")
      @ticket = ticket_ele.blank? ? "" : ticket_ele.content.strip
    end
  end

end