# http://www.focalprice.com/

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'


$product_list = String.new()  # list of links to products
$actual_details = Array.new() # messaging array for product output
$actual_details_xml = Array.new()  # messaing array for xml outputs
$product_num = 48   #number of scrapped products


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


def output_to_stdout(prod_ar)
  print prod_ar[0]
  print prod_ar[1]
  print prod_ar[2]
  print prod_ar[3]
  print prod_ar[4]
  print prod_ar[5]
  print prod_ar[6]
end


def output_to_txt(prod_ar)
  $prod_file << prod_ar[0]
  $prod_file << prod_ar[1]
  $prod_file << prod_ar[2]
  $prod_file << prod_ar[3]
  $prod_file << prod_ar[4]
  $prod_file << prod_ar[5]
  $prod_file << prod_ar[6]
end

def output_to_csv(prod_ar)
  $csv_file << prod_ar
end

def output_to_xml(prod_ar)
  puts "Creating XML output file..."

  prod_titles = ["Product Name", "Product Code", "Unit Price", "Tax", "Description"]
  row_num = '1'
  i = 0
  builder = Nokogiri::XML::Builder.new do
    Products {
      for row_num in 1..$product_num
        row('no' => row_num.to_s) {
          prod_titles.each do |o|
            FL('val' => o) {
              text prod_ar[i].gsub(/\$/, '')
              i = i + 1
            }
          end
        }
      end
    }
  end

  $xml_file << builder.to_xml
  #puts builder.to_xml

end

def filling_fields(type)
  puts "Creating output product list file..."

  $product_list.each_line do |product|
    url = product
    doc = Nokogiri::HTML(open(url))

    # generating for stdout output
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

    $actual_details << title + "\n"
    $actual_details << sku + "\n"
    $actual_details << price + "\n"
    $actual_details << discount + "\n"
    $actual_details << description + "\n"
    $actual_details << details
    $actual_details << "\n\n"


    # generating for xml  output
    title_xml = doc.at_css("h1").text
    sku_xml = doc.at_css(".d_psku").text.gsub(/SKU:/, "")
    price_xml = doc.at_css(".Priceus").text[/\$[0-9\.]+/]
    discount_xml = doc.css("div.wholesale table").text[/\$ [0-9\.]+ \$ [0-9\.]+\$ [0-9\.]+/]
    description_xml = String.new()
    doc.at_css(".goods_text").text.each_line do |desc|
      if desc != "\r\n"
        description_xml << desc.gsub(/\r\n/, ' ').gsub(/   /, '')
      end
    end

    $actual_details_xml << title_xml
    $actual_details_xml << sku_xml
    $actual_details_xml << price_xml
    $actual_details_xml << discount_xml
    $actual_details_xml << description_xml.inspect


    output = case type
      when "stdout" then output_to_stdout($actual_details)
      when "txt"    then output_to_txt($actual_details)
      when "csv"    then output_to_csv($actual_details)
      # when "xml"    then output_to_xml($actual_details_xml)
    end

    $actual_details.clear
  end

  if type == "xml"
    output_to_xml($actual_details_xml)
  end
end


def images_get()
  url = "http://www.focalprice.com/Apple-Accessoriesgoods_9_1_c.html"
  baseuri = URI.parse(url)
  doc = Nokogiri::HTML(baseuri.read)
  Dir.mkdir('scrapped_images')
  doc.search('img').each do | img |
    iuri = baseuri + URI.parse(img['src'])
    File.open('scrapped_images/' + File.basename(iuri.path), 'wb') do | f |
      f << iuri.read
    end
  end
end



def scrap_focalprice()
  #links_scrap()
  #output = case ARGV[1].to_s
  #    when "stdout" then
  #      filling_fields(ARGV[1].to_s)
  #    when "txt"    then
  #      $prod_file = File.new("product_list_focalprice.txt", "w") # out txt
  #      filling_fields(ARGV[1].to_s)
  #      $prod_file.close
  #    when "csv"    then
  #      $csv_file = CSV.open("product_list_focalprice.csv", "wb") # out csv
  #      filling_fields(ARGV[1].to_s)
  #      $csv_file.close
  #    when "xml"    then
  #      $xml_file = File.new("product_list_focalprice.xml", "w") # out xml
  #      filling_fields(ARGV[1].to_s)
  #      $xml_file.close
  #    else puts "Unknow output type"
  # end
  # images_get()
end

