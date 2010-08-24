# http://www.focalprice.com/

require 'rubygems'
require 'nokogiri'
require 'open-uri'

$product_list = String.new()  # list of links to products

def links_scrap()
  puts "Creating products links index..."
  page_start_number = 1
  page_last_number = 1

  for i in page_start_number..page_last_number
    url = "http://www.focalprice.com/Apple-Accessories_9_#{i}_n.html"
    doc = Nokogiri::HTML(open(url))

    l = doc.css("div.box_m a").map {|link| link['href']}
    num_per_page = l.size-1

    $product_list << l[0].to_s + "\n"
    for i in 1..num_per_page
     if ((l[i].to_s[0..3] <=> "http") == 0) && (i%2==0)
       $product_list << l[i].to_s + "\n"
     end
    end
  end

  # puts $product_list
  # puts l
end

def filling_fields()
  puts "Creating output product list file..."
  prod_file = File.new("product_list_focalprice.txt", "w")

  $product_list.each_line do |product|
    url = product
    doc = Nokogiri::HTML(open(url))

    title = "Title: " + doc.at_css("h1").text
    sku = doc.at_css(".d_psku").text
    price = "Price: " + doc.at_css(".Priceus").text[/\$[0-9\.]+/]
    discount = "Bulk Order Discount: " + doc.css("div.wholesale table").text[/\$ [0-9\.]+ \$ [0-9\.]+\$ [0-9\.]+/]
    description = String.new()
    description << "Description:"
    doc.at_css(".goods_text").text.each_line do |desc|
      if desc != "\r\n"
        description << "  " + desc
      end
    end
    description.chop!.chop!.chop!.chomp!
    details = doc.at_css(".TabContent div:nth-child(2)").text.gsub(/  /, "").gsub(/\r\n\t\t\t\r\n/, "")
    details.gsub!(/Pack including/, "\nPack including")

    prod_file << title + "\n"
    prod_file << sku + "\n"
    prod_file << price + "\n"
    prod_file << discount + "\n"
    prod_file << description + "\n"
    prod_file << details
    prod_file << "\n\n"
  end
end

def images_get()
  url = "http://www.focalprice.com/IP800B/Exquisite_Hard_Back_Case_Cover_for_Apple_iPhone_4G_Black.html"
  baseuri = URI.parse(url)
  doc = Nokogiri::HTML(baseuri.read)
  doc.search('img').each do | img |
    iuri = baseuri   + URI.parse(img['src'])
    File.open(File.basename(iuri.path), 'wb') do | f |
      f << iuri.read
    end
  end
end



def scrap_focalprice()
  #links_scrap()
  #filling_fields()
 images_get()
end

