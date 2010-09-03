require 'rubygems'
require 'nokogiri'
require 'open-uri'

# example-stub, may not work

def ebay_scrap(scr)
  product = scr
  url = "http://shop.ebay.com/?_from=R40&_trksid=p3907.m570.l1313&_nkw=#{product}&_sacat=See-All-Categories"
  doc = Nokogiri::HTML(open(url))

  puts url
  doc.css(".tp").each do |item|
    text = item.at_css(".v4lnk").text
    price = item.at_css(".prices").text + "rur"
    puts "#{text} - #{price}"
  end

end

