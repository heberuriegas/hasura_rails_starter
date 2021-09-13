class Onesignal::Notification < Aldous::Service
  def initialize options = {}
    options.reverse_merge!({type: :all})
    @options = options
    @type = options[:type]
  end

  def perform
    headings = OneSignal::Notification::Headings.new(en: @options[:title])
    contents = OneSignal::Notification::Contents.new(en: @options[:message])
    config = { headings: headings, contents: contents }
    case @type.to_sym
    when :all
      config[:included_segments] = [OneSignal::Segment::ACTIVE_USERS]
    when :users
      config[:included_targets] = OneSignal::IncludedTargets.new(include_player_ids: @options[:ids])
    when :segment
      config[:included_segments] = @options[:segments]
    end

    # Check for data
    if @options[:data].is_a?(Hash) and @options[:data].length > 0
      attachments = OneSignal::Attachments.new(data: @options[:data])
      config[:attachments] = attachments
    end
    notification = OneSignal::Notification.new(config)
    response = OneSignal.send_notification(notification)
    return Result::Success.new response: response
  end
end
