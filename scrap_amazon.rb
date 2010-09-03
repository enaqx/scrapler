require 'rubygems'
require 'nokogiri'
require 'open-uri'

# example-stub, may not work

def scrap_amazon(scr)
  product = scr
  url = "http://shop.ebay.com/?_from=R40&_trksid=p3907.m570.l1313&_nkw=#{product}&_sacat=See-All-Categories"
  doc = Nokogiri::HTML(open(url))

  puts url

end

