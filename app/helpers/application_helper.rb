module ApplicationHelper
  def pt_serif_url
    if offline_dev?
      '/assets/PT+Serif.css'
    else
      'http://fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic'
    end
  end

  def pt_sans_url
    if offline_dev?
      '/assets/PT+Sans.css'
    else
      'http://fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic'
    end
  end

  def jquery_url
    if offline_dev?
       javascript_include_tag "jquery"
    else
      javascript_include_tag 'http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js'
    end
  end

  def twitter_script
    unless offline_dev?
      <<-JAVASCRIPT
        (function(){
          var twitterWidgets = document.createElement('script');
          twitterWidgets.type = 'text/javascript';
          twitterWidgets.async = true;
          twitterWidgets.src = 'http://platform.twitter.com/widgets.js';
          document.getElementsByTagName('head')[0].appendChild(twitterWidgets);
        })();
      JAVASCRIPT
    end
  end

  def offline_dev?
    Rails.application.config.offline_dev
  end
end
