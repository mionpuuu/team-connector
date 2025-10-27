module ApplicationHelper
  def time_options_15_minutes
    options = []
    # 0時から23時までループ
    (8..12).each do |hour|
      # 0分、15分、30分、45分をループ
      [0, 15, 30, 45].each do |minute|
        # 時と分を2桁の文字列にフォーマット
        hour_str = format('%02d', hour)
        minute_str = format('%02d', minute)
        
        time_display = "#{hour_str}:#{minute_str}" # 表示用 (例: "09:00")
        time_value = time_display                   # 送信用 (例: "09:00")
        
        options << [time_display, time_value]
      end
    end
    options
  end
end
