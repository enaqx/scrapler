require 'rubygems'
require 'nokogiri'
require 'open-uri'

def ozon_scrap(scr)
  product = scr
  url = "http://www.ozon.ru/?context=search&text=#{product}"
  doc = Nokogiri::HTML(open(url))

  puts url
  doc.css(".td_tov_text").each do |item|
    text = item.at_css(".name_link a").text
    price = item.at_css("big").text
    puts "#{text} - #{price}"
  end

end
