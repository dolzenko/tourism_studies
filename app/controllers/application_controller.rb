class ApplicationController < ActionController::Base
  if Rails.env.production?
    def self.caches_all_pages(*actions)
      return unless perform_caching
      options = actions.extract_options!
      after_filter(options) do |c|
        c.expire_page
        c.cache_page
      end
    end

    caches_all_pages
  end
  
  def default_url_options
    { :format => :html }
  end 

  def url_for(options)
    url = super(options)
    if url =~ /^http/
      url
    elsif url =~ /^\//
      relative_to_request(url)
    else
      url
    end
  end

  def relative_to_request(absolute_path)
    request_dir_path = Pathname.new(File.dirname(request.path))
    
    Pathname.new(absolute_path).relative_path_from(request_dir_path).to_s rescue r(absolute_path, request_dir_path.to_s) 
  end
end
