require 'scrappers'

if ARGV[0] == nil
  puts "Insert e-shop name for price searching."
else
  if ARGV[0] == 'focalprice'
    scrap_focalprice()
  end

  if ARGV[0] == 'yallstore'
    scrap_yallstore()
  end

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

