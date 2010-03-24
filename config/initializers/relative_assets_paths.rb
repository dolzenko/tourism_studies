module RelativeAssetsPaths
  private
  
  def rewrite_asset_path(source)
    relative_to_request(source)
  end

  def relative_to_request(absolute_path)
    Pathname.new(absolute_path).relative_path_from(Pathname.new(File.dirname(request.path))).to_s
  end  
end

ActionView::Base.class_eval do
  include RelativeAssetsPaths
end