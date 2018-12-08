module ApplicationHelper
  def jquery_url
    if offline_dev?
       javascript_include_tag "jquery"
    else
      javascript_include_tag '//ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js'
    end
  end

  def offline_dev?
    Rails.application.config.offline_dev
  end
end
