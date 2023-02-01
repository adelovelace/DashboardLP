puts 'Scraper de Hoteles: Booking'

require 'open-uri'
require 'csv' # escribir y leer csv
require 'selenium-webdriver'
require 'rubygems'

require_relative './hotel'

# CSV.open('./Data/hoteles.csv', 'wb') do |csv|
#   csv << %w[id hotel precio puntaje link_hotel provincia]
# end

# Inputs
offset = 0
checkin =   '2023-02-01'
checkout =  '2023-02-03'
id = offset + 1

#Esmeraldas
# link = "https://www.booking.com/searchresults.en-gb.html?label=duc511jc-1FCAIoQUICZWNIM1gDaEGIAQGYAQm4AQfIAQzYAQHoAQH4AQ2IAgGoAgO4AqWU7Z0GwAIB0gIkOTNkY2I5NmYtMjRkZS00OGIzLWJkMDYtN2FjMzBhNGE1NDVh2AIG4AIB&sid=d937cab748728b6d0dd262df88420fff&aid=304142&ss=Esmeraldas&ssne=Esmeraldas&ssne_untouched=Esmeraldas&efdco=1&lang=en-gb&sb=1&src_elem=sb&src=searchresults&dest_id=13787&dest_type=region&checkin=#{checkin}&checkout=#{checkout}&group_adults=2&no_rooms=1&group_children=0&sb_travel_purpose=leisure&offset=#{offset}"


#Cuenca
# link = "https://www.booking.com/searchresults.en-gb.html?ss=Cuenca&ssne=Cuenca&ssne_untouched=Cuenca&label=duc511jc-1FCAIoQUICZWNIM1gDaEGIAQGYAQm4AQfIAQzYAQHoAQH4AQ2IAgGoAgO4AqWU7Z0GwAIB0gIkOTNkY2I5NmYtMjRkZS00OGIzLWJkMDYtN2FjMzBhNGE1NDVh2AIG4AIB&sid=d937cab748728b6d0dd262df88420fff&aid=304142&lang=en-gb&sb=1&src_elem=sb&src=searchresults&dest_id=-926345&dest_type=city&checkin=#{checkin}&checkout=#{checkout}&group_adults=2&no_rooms=1&group_children=0&sb_travel_purpose=leisure&offset=#{offset}"

#Quito
# link = "https://www.booking.com/searchresults.en-gb.html?ss=Quito&ssne=Quito&ssne_untouched=Quito&label=duc511jc-1FCAIoQUICZWNIM1gDaEGIAQGYAQm4AQfIAQzYAQHoAQH4AQ2IAgGoAgO4AqWU7Z0GwAIB0gIkOTNkY2I5NmYtMjRkZS00OGIzLWJkMDYtN2FjMzBhNGE1NDVh2AIG4AIB&sid=d937cab748728b6d0dd262df88420fff&aid=304142&lang=en-gb&sb=1&src_elem=sb&src=searchresults&dest_id=-932573&dest_type=city&checkin=#{checkin}&checkout=#{checkout}&group_adults=2&no_rooms=1&group_children=0&sb_travel_purpose=leisure&offset=#{offset}"

#Gye
link = "https://www.booking.com/searchresults.en-gb.html?ss=Guayaquil&ssne=Guayaquil&ssne_untouched=Guayaquil&label=duc511jc-1FCAIoQUICZWNIM1gDaEGIAQGYAQm4AQfIAQzYAQHoAQH4AQ2IAgGoAgO4AqWU7Z0GwAIB0gIkOTNkY2I5NmYtMjRkZS00OGIzLWJkMDYtN2FjMzBhNGE1NDVh2AIG4AIB&sid=d937cab748728b6d0dd262df88420fff&aid=304142&lang=en-gb&sb=1&src_elem=sb&src=searchresults&dest_id=-927505&dest_type=city&checkin=#{checkin}&checkout=#{checkout}&group_adults=2&no_rooms=1&group_children=0&sb_travel_purpose=leisure&offset=#{offset}"


driver = Selenium::WebDriver.for :chrome
driver.navigate.to link

hoteles_container = driver.find_elements(:xpath => "//*[@class='b978843432']")
provincia = driver.find_element(:xpath => "//*[@class='efdb2b543b']").find_element(:class => "e1f827110f").text.strip.split(":")[0]

until offset == 75 do

  hoteles_container.each do |hotel_post|

    nombre = hotel_post.find_element(:class, "fcab3ed991").text.strip

    href_hotel = hotel_post.find_element(:class, "e13098a59f").attribute('href')

    begin
      puntaje = hotel_post.find_element(:class, "d10a6220b4").text.strip
    rescue
      puntaje = -1
    end

    precio = hotel_post.find_element(:class, "fbd1d3018c").text.strip

    hotel = Hotel.new(id, nombre, precio, puntaje, href_hotel, provincia)
    hotel.guardar()
    id += 1

    puts("#{id}, #{nombre}, #{precio},#{puntaje}, #{href_hotel}, #{provincia}")
  end

  offset += 25

end
driver.close
