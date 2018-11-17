module ApplicationHelper
  def pt_serif_url
    if offline_dev?
      '/assets/PT-Serif.css'
    else
      '//fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic'
    end
  end

  def pt_sans_url
    if offline_dev?
      '/assets/PT-Sans.css'
    else
      '//fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic'
    end
  end

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
