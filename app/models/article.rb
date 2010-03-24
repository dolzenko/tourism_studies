# encoding: utf-8
require "fileutils"
require "transliteration"

class Article < ActiveRecord::Base
  DATA_ROOT = Rails.root + "db/models"
  before_save :sync_filesystem_attrs
  after_create :init_filesystem_attrs
  validate :title => :presence

  acts_as_tree :order => :position
  
  def content
    if file = filesystem_attr_file
      IO.read(file)
    else
      self[:content]
    end
  end
  alias :content_before_type_cast :content 

  def content=(val)
    @content = val
  end

  def data_root
    DATA_ROOT + self.class.table_name
  end

  def model_dir_glob(attribute)
    data_root + "#{ id }{,-*}/#{ attribute }.html.erb"
  end

  def filesystem_attr_file
    Dir[model_dir_glob(:content)][0]
  end

  def sync_filesystem_attrs
    return unless defined?(@content)
    return unless filesystem_attr_file
    if title_changed?
      old_path = File.dirname(filesystem_attr_file)
      new_path = File.dirname(generate_path)
      FileUtils.mv(old_path, new_path)
    end
    File.open(filesystem_attr_file, "w") do |file|
      file.write(@content)
    end
  end

  def expose_filesystem_attrs
    File.open(filesystem_attr_file, "w") do |file|
      file.write(self[:content])
    end
  end

  def init_filesystem_attrs
    file = generate_path 

    FileUtils.mkdir_p(File.dirname(file))
    File.open(file, "w") do |file|
      file.write(self[:content])
    end
  end

  def generate_path
    data_root + "#{ to_param }/content.html.erb"
  end

  def to_param
    if title.present?
      "#{ id }-#{ ::Transliteration.transliterate(title.force_encoding("utf-8")).downcase.gsub(/[\s\.:_]+/, '-').gsub(/[^-a-z0-9~;+=_]/, '') }"[0..50]
    else
      "#{ id }"
    end
  end

  def fixup_paramed_dir
    old_path = File.dirname(filesystem_attr_file)
    new_path = File.dirname(generate_path)
    FileUtils.mv(old_path, new_path) unless old_path == new_path
  end

  def self.fixup_paramed_dirs
    find_each(&:fixup_paramed_dir)
  end
end
