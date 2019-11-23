module FormatHelper

  def humanize_seconds(seconds)
    if seconds > 59 * 60 + 59
      Time.at(seconds).utc.strftime("%H:%M:%S")

    else
      Time.at(seconds).utc.strftime("%M:%S")
    end
  end

end
