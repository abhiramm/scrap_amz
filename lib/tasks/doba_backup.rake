
namespace :products do
        task :from_doba_com => :environment do
                book = Spreadsheet::Workbook.new
                sheet1 = book.create_worksheet
                sheet1.row(0).concat ['supplier_id', 'drop_ship_fee', 'supplier_name', 'product_id', 'product_sku', 'title', 'warranty', 'description', 'condition', 'details', 'manufacturer', 'brand_name', 'case_pack_quantity', 'country_of_origin', 'item_id', 'item_sku', 'mpn', 'upc', 'item_name', 'item_weight', 'ship_alone', 'ship_freight', 'ship_weight', 'ship_cost', 'max_ship_single_box', 'map', 'price', 'custom_price', 'prepay_price', 'street_price', 'msrp', 'qty_avail', 'stock', 'categories', 'attributes', 'image_name', 'small_image_url', 'medium_image_url', 'large_image_url', 'is_customized'] 
                a = Mechanize.new { |agent|
                        agent.user_agent_alias = 'Mac Safari'
                }
                        i = 1
                auth_page = a.get('https://www.doba.com/login/')
                auth_form = auth_page.form
                auth_form.username = 'amanueltesfalem@teleworm.us'
                auth_form.password = 'Waran2014'
                search_page = a.submit(auth_form)
                puts "search Page #{search_page}"

                search_form = search_page.form
                search_form.term = "Disney Frozen Deluxe Elsa Toddler-Child Costume|Medium (7-8)"
                #hiddern temporarily search_result_page = a.submit(search_form)
#                catalog_page = a.get("https://www.doba.com/members/catalog")
 #               category_pages = catalog_page.search('#top_categories a')

                pages_list = ['https://www.doba.com/members/catalog/search?terms=Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29&term=+Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29&submitted=Go&min_price=&max_price=&adv_filter_update%5B%5D=0&shipping_filter=all&min_qty=0&adv_filter_update%5B%5D=0&adv_filter_update%5Brefurbished%5D=on&min_shiptime=&max_shiptime=&min_instock=&max_instock=&status=&estimated_available=', 'https://www.doba.com/members/catalog/search/start/24/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/1::0___refurbished::1', 'https://www.doba.com/members/catalog/search/start/48/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/refurbished::1___1::0', 'https://www.doba.com/members/catalog/search/start/72/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/refurbished::1___1::0', 'https://www.doba.com/members/catalog/search/start/96/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/refurbished::1___1::0', 'https://www.doba.com/members/catalog/search/start/120/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/refurbished::1___1::0', 'https://www.doba.com/members/catalog/search/start/144/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/refurbished::1___1::0', 'https://www.doba.com/members/catalog/search/start/168/sort_by/relevance/term/Disney+Frozen+Deluxe+Elsa+Toddler-Child+Costume%7CMedium+%287-8%29/adv_filter/refurbished::1___1::0']
                pages_list.each do |p|
                        search_result_page = a.get(p)
#                        puts "Search Result Page #{search_result_page}"
                #
#                        binding.pry
                        

                        item_links = search_result_page.search('.catalog_item .title a')
                 puts "item_links #{item_links}"
                        item_links.each do |l|
                         link = "https://doba.com" + l.attr('href')
                        item_page = a.get(link)
                        catalog_product = item_page.search('.catalog_product')
                        product_info = catalog_product.search('#product_info')
                        inventory_stats = catalog_product.search('#inventory_stats')
                        supplier_id = ""
                        drop_ship_fee = inventory_stats.search('#product_pricing_information td')[1].text.strip
                        supplier_name = catalog_product.search('.supplier td a').text
                        puts "supplier_name #{supplier_name}"
                        product_sku = product_info.search('table')[0].search('td')[3].text.strip
                        puts "sku #{product_sku}"
                        product_title = product_info.search("#title").text.strip
                        puts "Product Title #{product_title}"
                        warranty = ""
                        description = catalog_product.search('.description tr td').text.strip
                        puts "Description #{description}"
                        condition = inventory_stats.search('#cond strong').text.strip
                        puts "condition #{condition}"
                        details = catalog_product.search('p')[2].text.strip
                        puts "Details #{details}"
                        if catalog_product.search('.product_details td').first
                        manufacturer = catalog_product.search('.product_details td').first.text.strip
                        else
                                manufacturer = ""
                        end
                        brand_name = ""
                        case_pack_quantity = ""
                        country_of_origin = ""
                        item_id = product_info.search('#item-id').text.strip
                        puts "item_id #{item_id}"
                        item_sku = product_sku
                        mpn = ""
                        upc = product_info.search('#upc').text.strip
                        item_name = product_title
                        item_weight = product_info.search('#product_stats_inner tr.rule td').last.text.strip
                        ship_weight = item_weight
                        ship_alone = ""
                        ship_freight = ""
                        ship_cost = inventory_stats.search('table td').last.text.strip
                        max_ship_single_box = ""
                        map = ""
                        price = inventory_stats.search('table .price').text.split(' ').first
                        puts "price #{price}"
                        custom_price = ""
                        prepay_price = inventory_stats.search('table td')[0].text.strip
                        puts "prepay price #{prepay_price}"
                        street_price = ""
                        msrp = product_info.search('#product_stats_inner table td')[0].text.strip
                        puts "msrp #{msrp}"
                        qty_avail = inventory_stats.search("#quant span").text.strip
                        stock = ""
                        category = catalog_product.search("#catalog_breadcrumb a")
                        puts "category #{category}"
                        categories = "#{category[1].text if category[1]} > #{category[2].text if category[2]} > #{category[3].text if category[3]}"
                        puts "categories #{categories}"
                        attributes = ""
                        small_image_url = catalog_product.search(".image_wrapper .img_actions a").last.attr('href').split("&as").first
                        large_image_url = small_image_url.split('?').first
                        medium_image_url = large_image_url + "?maxX=500&maxY=500"
                        image_name = large_image_url.split('/').last
                        product_link = link.split('/')
                        product_id = product_link[13]
                      `wget #{large_image_url} -P IMAGES` 
                        puts "large_image_url #{large_image_url}"
                        is_customized = ""
                       sheet1.row(i).concat [supplier_id, drop_ship_fee, supplier_name, product_id, product_sku, product_title, warranty, description, condition, details, manufacturer, brand_name, case_pack_quantity, country_of_origin, item_id, item_sku, mpn, upc, item_name, item_weight, ship_alone, ship_freight, ship_weight, ship_cost, max_ship_single_box, map, price, custom_price, prepay_price, street_price, msrp, qty_avail, stock, categories, attributes, image_name, small_image_url, medium_image_url, large_image_url, is_customized]  
                       i = i + 1 
                        book.write 'public/doba_data.xls'
                        end 
                end
        end
end
