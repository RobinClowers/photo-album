module ApplicationHelper
  def pt_serif_url
    if ENV['OFFLINE'] == 'true'
      '/assets/PT+Serif.css'
    else
      'http://fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic'
    end
  end

  def pt_sans_url
    if ENV['OFFLINE'] == 'true'
      '/assets/PT+Sans.css'
    else
    end
  end

  def jquery_url
    if ENV['OFFLINE'] == 'true'
       javascript_include_tag "jquery"
    else
      tag('script', src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js')
    end
  end
end
