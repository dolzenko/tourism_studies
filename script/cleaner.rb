# -*- encoding: utf-8 -*-

require "English"

input = nil

File.open(ARGV[0], "r:windows-1251:utf-8") do |file|
  input = file.read
end

result = input.gsub(/<([\/]{0,1})(\w+).*?>/m) do |tag_match|
  # remove all styles
  # remove all tags except p
  # p change to div
  if $2 == "p"
    "<#{ $1 }div>"
  else
    ""
  end
  #puts $MATCH
  #puts "#{ $1 } #{ $2 }"
end

# result.gsub!(/[ \u00A0+]/, " ")
result.gsub!(/[ \u00A0]+/, " ")

puts result