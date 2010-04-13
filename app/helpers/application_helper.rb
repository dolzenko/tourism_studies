module ApplicationHelper
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
