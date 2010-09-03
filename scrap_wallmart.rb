require 'rubygems'
require 'nokogiri'
require 'open-uri'

# example-stub, may not work

def scrap_wallmart(scr)
  product = scr
  url = "http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=#{product}&Find.x=0&Find.y=0&Find=Find"
  doc = Nokogiri::HTML(open(url))

  puts url
  doc.css(".item").each do |item|
    text = item.at_css(".prodLink").text
    price = item.at_css(".PriceXLBold, .PriceCompare .BodyS").text[/\$[0-9\.]+/]
    puts "#{text} - #{price}"
  end
end

