#! ruby -Ku

#price_room =[]
#price_expense =[]
module Get_all_list

def make_array(p_p,room,expense)
          p_p.puts room
          p_p.puts expense
end 
  def all_list()
#ケア以外取得
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    require 'kconv'
    #require 'logger'
    require 'mysql'

property_name=[] 
address =[]
access =[]
room_size = []
rooms_space =[]
establish_year =[]
price_room =[]
price_expense =[]
amenity_net=[]
amenity_lock=[]
amenity_air=[]
amenity_closet=[]
amenity_bath=[]
amenity_lav=[]
amenity_flooring=[]
amenity_washing=[]
amenity_box=[]
amenity_pet=[]

    puts "check 1"
    sitemap_url = 'http://www.weekly-mansion.com/tokyo/search/list_add.html?jyuusyo_cd=13104'
    sitemap_url = 'http://www.weekly-mansion.com/tokyo/search/list_add.html?jyuusyo_cd=13104'
    puts "check 2"
    reg=/http:\/\/www.p-tano.com\/category\/(?!(care)).+\/.+\/$/
    puts "check 3"
#    logfile_name = "list_tanomail"+Time.now.strftime("%Y%m%d-%H%M%S")+".log"
    output_file = '/root/aomori/weekly/log_storage/weekly_mansion.html'
    outcome_file = '/root/aomori/weekly/log_storage/outcome.log'
    outcome_price_file = '/root/aomori/weekly/log_storage/outcome_price.log'
    outcome_address_file = '/root/aomori/weekly/log_storage/outcome_address.log'
    outcome_access_file = '/root/aomori/weekly/log_storage/outcome_access.log'
    outcome_rooms_file = '/root/aomori/weekly/log_storage/outcome_rooms.log'
    outcome_amenity_equipments_file = '/root/aomori/weekly/log_storage/outcome_equipments.log'
    outcome_establish_year_file = '/root/aomori/weekly/log_storage/outcome_establish_year.log'

    p system('/usr/bin/phantomjs /root/aomori/weekly/more_info.js ' + sitemap_url + ' > ' + output_file)
    address_and_reasonable_price = {}
   
    #logger = Logger.new(outcome_file)
    outcome = File.open(outcome_file,"w" )
    outcome_price = File.open(outcome_price_file,"w" )
    outcome_rooms = File.open(outcome_rooms_file,"w" )
    outcome_address = File.open(outcome_address_file,"w" )
    outcome_access = File.open(outcome_access_file,"w" )
    outcome_equipments = File.open(outcome_amenity_equipments_file,"w" )
    outcome_establish_year = File.open(outcome_establish_year_file,"w" )
    s = File.read(output_file, :encoding => Encoding::UTF_8)
    s.gsub!(/\^Z/,"")
    p "before nokogiri"
    doc=Nokogiri::HTML(s.to_s)
    #puts doc
    #neColumn > #wrap > form > #content > #mainContent > div > #summaryArea > div > div.innner > table > tbody > tr > td"
    #exit
    puts "check 4"
    #property_name_selector = 'html > #twoColumn > #wrap > from > #content > #mainContent > div > div > div > div > div > h4 > a.linkTarget'
    property_name_selector = '#wrap > form > #content > #mainContent > div > div > div > div > div > h4 > a.linkTarget'
    #access_selector = 'html > #twoColumn > #wrap > form > #content > #mainContent > div.section > div > div > div > div > div.detailWrap > div > div > div > dl > dd'
    access_selector = '#wrap > form > #content > #mainContent > div.section > div > div > div > div > div.detailWrap > div > div > div > dl > dd'
    access_selector = '#wrap > form > #content > #mainContent > div.section > div > div > div > div'
    selector_str = '#wrap > form > #content > #mainContent > div > div'
    sub_selector = 'div.detailInner > div.layout01 > dl > dd'
    #price_selector = '#wrap > form > #content > #mainContent > div > div >div > div > div > div.detailArea > div > table > tbody > tr > td'
    price_selector = '#wrap > form > #content > #mainContent > div > div >div > div > div'
    #price_selector = 'div > div > div > div > div > table > tbody > tr.style02'
    #price_selector = 'div > div > div.price'
    sub_price_selector = 'div.detailArea > div > table > tbody > tr > td'
   #間取り
    rooms_selector = '#twoColumn > #wrap > form > #content > #mainContent > div > div > div > div > div > div.detailArea > div > div > dl > dd'
    rooms_selector = '#twoColumn'
    rooms_selector = 'div.detailInner > div.layout01 > dl > dd'
    establish_year_selector = 'div.detailInner > div.layout02 > dl > dd'
    establish_year_selector ='#wrap > form > #content > #mainContent > div > div > div > div > div > div.detailArea > div > div > dl > dd'
    sub_establish_year_selector = 'dd'
    taking_time_to_go_to_station_selector ='#wrap > form > #content > #mainContent > div > div > div > div > div >div.detailArea > div > div > dl > dd > div'
    amenity_equipments_selector = '#wrap > form > #content > #mainContent > div > div > div > div > div > div > div > ul > li > img'

    #doc.css(access_selector).each do |way_to_destination|
    doc.xpath('//div[@class="layout02"]/dl').each do |way_to_destination|

      if /(^\s+)/ =~ way_to_destination.xpath("./dd/text()").to_s
      access.push(way_to_destination.xpath("./dd/text()").to_s.strip)
      outcome_access.puts way_to_destination.xpath("./dd/text()").to_s.strip
      end
    end
    doc.css(property_name_selector).each do |name|
      #outcome.puts name.inner_text
      property_name.push(name.inner_text)
    end
    
    #間取り値抽出
      doc.css( rooms_selector.to_s ).each do |sub|
       #outcome_rooms.puts sub.attr("img")
        #outcome_rooms.puts sub.dd().inner_text
        puts sub
        if /<dd>([0-9]+(K|R|LDK|DK))/ =~ sub.to_s
        room_size.push( $1 )
        elsif /<dd>([0-9]+\w[^KR][^\<\/dd\>]+)/ =~ sub.to_s
        rooms_space.push( $1 )
        end
        #puts sub
        outcome_rooms.puts sub.to_s
      end

      doc.css( establish_year_selector.to_s ).each do |sub|
        if sub.to_s =~ /.*<dd>([0-9]+年[0-9]+月)/ 
        #if sub.to_s =~ /.*<dd>(.*年.*月) /
          establish_year.push( $1 )
          outcome_establish_year.puts sub.to_s
        end
      end
      doc.css( amenity_equipments_selector ).each do |sub|
      #onoff = sub.attr('src').match(/^\/\w*icon_detail*(_on | _off)\.gif/)
        if /(icon_.*)/ =~ sub.attr('src').to_s 
          case $1 
          when  "icon_detailNet_on.gif" then
            amenity_net.push(true)
          when  "icon_detailNet_off.gif" then
            amenity_net.push(false)
          when  "icon_detailLock_on.gif" then
            amenity_lock.push(true)
          when  "icon_detailLock_off.gif" then
            amenity_lock.push(false)
          when  "icon_detailAir_on.gif" then
            amenity_air.push(true)
          when  "icon_detailAir_off.gif" then
            amenity_air.push(false)
          when  "icon_detailCloset_on.gif" then
            amenity_closet.push(true)
          when  "icon_detailCloset_off.gif" then
            amenity_closet.push(false)
          when  "icon_detailBath_on.gif" then
            amenity_bath.push(true)
          when  "icon_detailBath_off.gif" then
            amenity_bath.push(false)
          when  "icon_detailLav_on.gif" then
            amenity_lav.push(true)
          when  "icon_detailLav_off.gif" then
            amenity_lav.push(false)
          when  "icon_detailFlooring_on.gif" then
            amenity_flooring.push(true)
          when  "icon_detailFlooring_off.gif" then
            amenity_flooring.push(false)
          when  "icon_detailWashing_on.gif" then
            amenity_washing.push(true)
          when  "icon_detailWashing_off.gif" then
            amenity_washing.push(false)
          when  "icon_detailBox_on.gif" then
            amenity_box.push(true)
          when  "icon_detailBox_off.gif" then
            amenity_box.push(false)
          when  "icon_detailPet_on.gif" then
            amenity_pet.push(true)
          when  "icon_detailPet_off.gif" then
            amenity_pet.push(false)
          end

          #outcome_equipments.puts amenity_pet
        end

   outcome_equipments.puts amenity_box
      end
      doc.css(selector_str.to_s + ' > div.box.linkBoxMultiple').each do |sub|
        puts "*" * 20
        #puts sub.css(sub_selector).count
        #outcome_price.puts sub
        #outcome_price.puts sub.css(sub_selector)
        #住所
       outcome_address.puts sub.css(sub_selector)[0].inner_text 
        address.push( sub.css(sub_selector)[0].inner_text )
#        puts sub
#        sub.css(price_selector).each do |price|
#          puts "#" * 20
#          puts price
#          puts "#" * 20
#        end
#      exit

      doc.css( price_selector).each do | price |
          outcome_price.puts price.css(sub_price_selector).inner_text
         serial_price = price.css(sub_price_selector).inner_text.to_s
         #outcome_price.puts  price.css(sub_price_selector).inner_text.to_s
        #if /^([0-9]+,[0-9]+?円).日([0-9]+,[0-9].?円) / =~ serial_price.to_s then
      #if /^([0-9]+,[0-9]+?円).日([0-9,w-z]+円)/ =~ serial_price.to_s then
      if /^([0-9w-z,]+)円\/日([0-9w-z,]+)円\/日/ =~ serial_price.to_s then
          #outcome_price.puts "kekka #{$1} #{$2} "
          #outcome_price.puts serial_price.to_s
          price_room.push($1)
          price_expense.push($2)
      elsif /^([0-9w-z,]+)円\/日[0-9w-z,]+円\/月.([0-9,w-z]+)円\/日/ =~ serial_price.to_s then
          #outcome_price.puts serial_price.to_s
          price_room.push($1)
          price_expense.push($2)
      elsif serial_price.to_s == "" then
          #price_room.push(0)
          #price_expense.push(0)
        next
      end
      #make_array(outcome_price,price_room,price_expense)
        #m = serial_price.match(/^(\d{1}\,\d{3})円\/日.*/)
        #m = serial_price.match(/^( (\d+\,\d+)円\/日.* | お問い合わせください).* /)
        #m = serial_price.match(/^(\d+\,\d+)円\/日.*/)
        #outcome_price.puts $1 

        #serial_price =~  %r{ (^\d.*)/日.* }
        #puts $~
     # if $1 == nil then next end
     # address_and_reasonable_price[ sub.css(sub_selector)[0].inner_text ] = $1

     # address_and_reasonable_price.each{ |key,value| 
     #     outcome_price.puts(key + "=>" , value)
     # } 
      #puts address_and_reasonable_price[ sub.css(sub_selector)[0].inner_text ] 
        end
       #logger.debug( sub.css(sub_selector)[0].inner_text )
        #puts sub.css(sub_selector)[1].inner_text
        #puts sub.css(sub_selector)[2].inner_text
        #sub.css(sub_selector).each do |addr|
        #  puts addr.inner_text
        #  puts "-" * 20
        #  #puts addr[0].inner_text
        #end
      end
      #s.close
      outcome.close

      client = Mysql::new('localhost','root','dcxsw23e','scraping')
      st = client.prepare("INSERT INTO weekly_mansion_info(property_name,establish_year,rental_fee,expense,room_space,room_size,address,access,detail_net,detail_companion_animal,detail_lock,detail_bath,detail_lav,detail_flooring,detail_washing,detail_box,detail_air,detail_closet) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? );")
      for num in  0..(property_name.length) -1 do
      st.execute("#{property_name[num]}","#{establish_year[num]}","#{price_room[num]}","#{price_expense[num]}","#{rooms_space[num]}","#{room_size[num]}","#{address[num]}","#{access[num]}","#{amenity_net[num]}","#{amenity_pet[num]}","#{amenity_lock[num]}","#{amenity_bath[num]}","#{amenity_lav[num]}","#{amenity_flooring[num]}","#{amenity_washing[num]}","#{amenity_box[num]}","#{amenity_air[num]}","#{amenity_closet[num]}")
      end
      
      #stmt = client.query("INSERT INTO weekly_mansion_info(property_name,establish_year) VALUES ('メゾン新宿', 2013 );")
      #stmt.execute 'メゾン新宿',2013
#exit


      puts doc.css(selector_str)[0].inner_text
      exit
      doc.css(selector_str).each do |line|
        puts "-" * 20
        puts line.inner_text
        puts "*" * 20
      end
    exit
      doc.css('div#wrap > div#tano-container-left > div#tano-content-top > div#tano-main-area').each do |link|
        puts "start 2"
        puts link
        id_url=link.attr("href")
        if id_url=~ reg then
          doc_sub = Nokogiri::HTML(open(id_url))
          category_name=link.text
          category_id=doc_sub.search("input[@id='target_category_id']")[0]['value']
          id_name_list[category_id]=category_name
          f.puts category_id.to_s+":"+category_name.to_s
        end
      end
      puts "check99"
#    f.close
  end
end   

#--TEST Code
include Get_all_list
puts "start111"
puts "check 0"
Get_all_list.all_list()

#id_name_list.each do |k,v|
#  p "#{k+":"+v}"
#end
#! ruby -Ku
