require 'rubygems'
require 'nokogiri'
require 'open-uri'

# example-stub, may not work

def scrap_buycom(scr)
  product = scr
  url = "http://www.buy.com/retail/usersearchresults.asp?querytype=home&qu=#{product}&qxt=home&display=col"
  doc = Nokogiri::HTML(open(url))

  puts url
  doc.css("form").each do |item|
    text = item.at_css(".medBlueText b").text
    price = item.at_css(".adPrice b").text[/\$[0-9\.]+/]
    puts "#{text} - #{price}"
  end
end

