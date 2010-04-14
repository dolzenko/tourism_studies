require "fileutils"
require "rails/console/app"

class StaticBuilder
  include Rails.application.routes.url_helpers

  def self.build
    ActionController::Base.page_cache_directory = "build" # ???
    new.build
  end

  def build
    purge_build_dir

    cache_paths

    copy_public

    cleanup_unused
  end

  def build_dir
    Rails.root + "build"
  end

  def cache_paths
    paths = []
    paths << "/index"
    paths << "/articles"
    paths += Article.all.map { |a| article_path(a) }
    paths.each(&method(:get))
  end

  def purge_build_dir
    puts "Purging everything beneath #{ build_dir }"
    FileUtils.rm_rf(Dir[build_dir + "*"]) #  don't touch the build/ dir itself
  end

  def get(path)
    p = "#{ path }.html"
    puts "Caching #{ p }"

    unless app.get(p) == 200
      raise "Failed to get #{ p }"
    end
  end

  def copy_public
    puts "Copying public/ dir to build/"
    FileUtils.cp_r(Rails.root + "public/.", build_dir)
  end

  def cleanup_unused
    FileUtils.rm build_dir + ".gitignore"
    FileUtils.rm Dir[build_dir + "**/*.erb"]
  end
end