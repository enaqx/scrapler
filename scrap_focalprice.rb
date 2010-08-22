# http://www.focalprice.com/

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def links_scrap()
  page_number = 1
  url = "http://www.focalprice.com/Apple-Accessories_9_#{page_number}_n.html"
  doc = Nokogiri::HTML(open(url))

  l = doc.css("div.box_m a").map {|link| link['href']}

  product_list = String.new()
  product_list << l[0].to_s + "\n"
  for i in 1..l.size-1
     if ((l[i].to_s[0..3] <=> "http") == 0) && (i%2==0)
       product_list << l[i].to_s + "\n"
     end
  end

  puts product_list
  # puts l

end

def pages_num()
  page_number = 1
  url = "http://www.focalprice.com/Apple-Accessories_9_#{page_number}_n.html"
  doc = Nokogiri::HTML(open(url))

  l = doc.css("div.pages")
  puts l
end

def images_get()
  url = "http://www.focalprice.com/IP800B/Exquisite_Hard_Back_Case_Cover_for_Apple_iPhone_4G_Black.html"
  baseuri = URI.parse(url)
  doc = Nokogiri::HTML(baseuri.read)
  doc.search('img').each do | img |
    iuri = baseuri + URI.parse(img['src'])
    File.open(File.basename(iuri.path), 'wb') do | f |
      f << iuri.read
    end
  end
end



def scrap_focalprice()
  # links_scrap()
  # pages_num()
  images_get()
end

