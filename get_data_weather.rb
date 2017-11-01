require 'capybara'
require 'capybara/poltergeist'
require 'mysql'


include Capybara::DSL
Capybara.default_driver = :poltergeist

options = {:js_errors => false}
Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.exact = true
 

#setting up the user agent of the headless browser
#Capybara.headers = { 'User-Agent' => "Mozilla/4.0 (Macintosh; Intel Mac OS X)" }

# open site
visit "http://www.meteoam.it"

# fill city on search form
fill_in("edit-ricerca-localita",:with => ARGV[0])
# click to search
click_on("edit-ricerca-localita-submit")

# get today data
#today_tb=find_by_id("oggi").text
# get "Fen. Intensi" -> 1st td on tb is an img, title is the data, so get all "td" and get title of img
#today_fn=today_tb_all[0].find("img").native.attributes
# get "temo" -> 2st td on tb is an img, title is the data, so  get title of img
#today_wd=today_tb_all[1].find("img").native.attributes
  
# get today data: get all td on table "oggi" 
today_th_all=find_by_id("oggi").all("th")
today_td_all=find_by_id("oggi").all("td")



to_th_var=""

# loop over the "th" of table 
today_th_all.each do | today_th |
 	to_th_var=to_th_var+"#"+today_th.text
end 

to_td_var=to_th_var
# loop over the "td" of table 
today_td_all.each do | today_td |
	if  today_td.has_selector?("img")  
 		to_td_var=to_td_var+"#"+today_td.find("img").native.attributes["title"]
 	else 
		to_td_var=to_td_var+"#"+today_td.text
	end
end 

# get tomorrow data
find_by_id("pannelli").click_on("Domani")
# get tomorrow data: get all td on table "domani" 
tomorrow_th_all=find_by_id("domani").all("th")
tomorrow_td_all=find_by_id("domani").all("td")

tm_th_var=""

# loop over the "th" of table 
tomorrow_th_all.each do | tomorrow_th |
 	tm_th_var=tm_th_var+"#"+tomorrow_th.text
end 

tm_td_var=tm_th_var
# loop over the "td" of table 
tomorrow_td_all.each do | tomorrow_td |
	if  tomorrow_td.has_selector?("img")  
 		tm_td_var=tm_td_var+"#"+tomorrow_td.find("img").native.attributes["title"]
 	else 
		tm_td_var=tm_td_var+"#"+tomorrow_td.text
	end
end 
 
# get the day after tomorrow data
find_by_id("pannelli").click_on("Dopodomani")
 # get tomorrow data: get all td on table "domani" 
day_after_tomorrow_th_all=find_by_id("tregiorni").all("th")
day_after_tomorrow_td_all=find_by_id("tregiorni").all("td")


tat_th_var=""

# loop over the "th" of table 
day_after_tomorrow_th_all.each do | day_after_tomorrow_th |
 	tat_th_var=tat_th_var+"#"+day_after_tomorrow_th.text
end 

tat_td_var=tat_th_var
# loop over the "td" of table 
day_after_tomorrow_td_all.each do | day_after_tomorrow_td |
	if  day_after_tomorrow_td.has_selector?("img")  
 		tat_td_var=tat_td_var+"#"+day_after_tomorrow_td.find("img").native.attributes["title"]
 	else 
		tat_td_var=tat_td_var+"#"+day_after_tomorrow_td.text
	end
end
#puts to_td_var
#puts tm_td_var
#puts tat_td_var
begin
# mysql connect
con = Mysql.new "localhost","root","pass","wp_main1"

# query update
con.query("UPDATE zx_crawler_iface SET v15='"+to_td_var+"', v16='"+tm_td_var+"', v17='"+tat_td_var+"' WHERE module_name='weather_46028'")
# query update
#con.query("INSERT INTO zx_crawler_iface(v15,v16,v17)  VALUES ('"+to_td_var+"','"+tm_td_var+"','"+tat_td_var+"')")
       
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end
 
puts "ok"
