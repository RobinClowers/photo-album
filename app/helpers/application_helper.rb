module ApplicationHelper
  def jquery_url
    if ENV['OFFLINE'] == 'true'
       javascript_include_tag "jquery"
    else
      tag('script', src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js')
    end
  end
end
