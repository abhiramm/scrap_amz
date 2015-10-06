namespace :products do
        task :from_alex_com => :environment do
                book = Spreadsheet::Workbook.new
                sheet1 = book.create_worksheet
                sheet1.row(0).concat ['Product Name', 'Manufacturer No', 'Product Price($)', 'Description Contains HTML', 'Product Description', 'Blow up Image Name', 'Small Image Url', 'Large Image1 Url', 'Blow Up Image1 Url', 'Main Category', 'Sub Category', 'Sub Sub Category', 'Sub Sub Sub Category', 'Product Customization', 'Customization Required', 'Total Options', 'Option_Choice_Style', 'Group Name'] 
                a = Mechanize.new { |agent|
                        agent.user_agent_alias = 'Mac Safari'
                }
                        i = 1
                next_page = ['http://www.aliexpress.com/w/wholesale-halloween-costumes.html?spm=2114.01020208.0.308.BDtBOY&initiative_id=SB_20150923065059&site=glo&g=y&shipCountry=us&SearchText=halloween+costumes', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=2&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=3&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=4&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=4&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=6&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=7&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=7&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=8&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=9&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=10&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n', 'http://www.aliexpress.com/wholesale?site=glo&g=y&SearchText=halloween+costumes&page=11&initiative_id=SB_20150923065059&shipCountry=US&needQuery=n']
                next_page.each do |p|
                page = a.get(p)
                page.search('#main-wrap h3 a').each do |l|
                        begin
                        url = l.attributes['href'].to_s

                        puts "URL #{url}"
                        product_page = a.get(url)
                        product_name = product_page.search('.main-wrap .product-name').text
                        product_price =  product_page.search('.main-wrap #sku-discount-price').text
                        product_description = product_page.search('.product-custom-desc')
#                        product_desc_html = product_description.children
                        main_category = product_page.search('.ui-breadcrumb a')[2].text
                        sub_category = product_page.search('.ui-breadcrumb a')[3].text
                        sub_sub_category = product_page.search('.ui-breadcrumb a')[4].text
                        sub_sub_sub_category = product_page.search('.ui-breadcrumb a')[5].text
                        image_page = a.get(product_page.search('.ui-image-viewer a').first.attributes['href'].to_s)
                        small_image_li =   image_page.search('.image-nav li a img')
                        large_image_li = image_page.search('ul.new-img-border li a img')
                        small_image_url =  "#{small_image_li[0].attributes["src"].value}, #{small_image_li[1].attributes["src"].value}, #{small_image_li[2].attributes["src"].value}".to_s
                         image_download = [small_image_li[0].attributes["src"].value.to_s, small_image_li[1].attributes["src"].value.to_s, small_image_li[2].attributes["src"].value.to_s, large_image_li[0].attributes["src"].value.to_s, large_image_li[1].attributes["src"].value.to_s, large_image_li[2].attributes["src"].value.to_s]  
                         large_image_url = "#{large_image_li[0].attributes["src"].value}, #{large_image_li[1].attributes["src"].value}, #{large_image_li[2].attributes["src"].value}".to_s
#                        binding.pry
                         image_download.each do|i|
#                               a.get(i).save_as "~/projects/amazon/public/#{i}.jpg" 
                                `wget #{i}`
                                 puts "downloading |"
                         end
                        blow_up_image_url = large_image_url
                        blow_up_image_name = "#{large_image_li[0].attributes["alt"].value}, #{large_image_li[1].attributes["alt"].value}, #{large_image_li[2].attributes["alt"].value}".to_s
                       puts "Small image URL: #{small_image_url}" 
                        sheet1.row(i).concat [product_name,'', product_price, '', product_description, blow_up_image_name, small_image_url, large_image_url, blow_up_image_url, main_category, sub_category, sub_sub_category, sub_sub_sub_category]
                        i = i + 1
                        rescue Exception => e
                                puts "ERROR OCCURED #{e}"
                                next
                        end
                end
                        book.write 'public/aliexpress_data.xls'
                end
        end
end
