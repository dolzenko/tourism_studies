module ArticlesHelper
  def article_asset_path(path)
    File.join("/models/articles/#{ @article.to_param }", path)
  end

  def article_image_tag(source, options = {})
    image_tag(article_asset_path(source), options)
  end
end
