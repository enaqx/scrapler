# insert records in zohocrm using api
require 'httpclient'

def get_file_as_string(filename)
  data = ''
  f = File.open(filename, "r")
  f.each_line do |line|
    data += line
  end
  return data
end


def get_ticket(servicename, loginid, pass)
  ticket = String.new()
  url = "http://accounts.zoho.com/login?servicename="+servicename+"&FROM_AGENT=true&LOGIN_ID="+loginid+"&PASSWORD="+pass

  clnt = HTTPClient.new
  content = clnt.get_content(url)

  content.each_line do |chunk|
    if chunk.match(/^TICKET/)
      ticket = chunk[7..-1]
    end
  end

  ticket
end


def insert_records()
  clnt = HTTPClient.new
  ticket = get_ticket("ZohoCRM","nickrivera","P@ssword123").chop;
  apikey = "49a194168c33db421fc4beb7d30cc135"
  newformat = "1"
  targeturl = "http://crm.zoho.com/crm/private/xml/Products/insertRecords"
  paramname = "content"
  xmldata = get_file_as_string(File.expand_path(File.dirname(__FILE__)).gsub(/zoho/, "product_list_focalprice.xml"))


  post_body = { "ticket" => ticket, "apikey" => apikey, "newFormat" => newformat, "xmlData" => xmldata}
  res = clnt.post(targeturl, post_body)
  puts post_body
  puts res
end


insert_records()

