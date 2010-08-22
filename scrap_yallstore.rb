# http://www.yallstore.com/
#
# YallStore specializes in the sales of laptop LCD screens, laptop batteries,
# laptop keyboards, laptop AC adapters, cell phone accessories, video game
# accessories, etc.

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def scrap_yallstore()
  url = "http://www.yallstore.com/video-games-c-762.html"
  doc = Nokogiri::HTML(open(url))

  puts url
  l = doc.css("div.centerColumn a").map {|link| link.content}
  p = doc.css("div.centerColumn span.productSpecialPrice").map {|link| link.content}


  product_list = String.new()
  for i in 1..l.size
    if l[i] != ''
      product_list << l[i].to_s + "\n"
    end
  end

  i = 1
  prod_file = File.new("product_list.txt", "w")
  for product in product_list.each_line
    if i%7 != 0
      prod_file << product
    end
    i = i + 1
  end

end

