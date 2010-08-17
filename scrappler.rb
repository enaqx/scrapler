require 'scrappers'

if (ARGV[0] && ARGV[1]) == nil
  puts "Insert e-shop name and product name for price searching."
else
 
  if ARGV[0] == 'buycom' 
    scrap_buycom(ARGV[1])
  end

  if ARGV[0] == 'amazon' 
    scrap_amazon(ARGV[1])
  end

  if ARGV[0] == 'ebay' 
    scrap_ebay(ARGV[1])
  end

  if ARGV[0] == 'ozon' 
    scrap_ozon(ARGV[1])
  end

  if ARGV[0] == 'wallmart' 
    scrap_wallmart(ARGV[1])
  end
end
