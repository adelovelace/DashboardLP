puts 'Scraper de Hoteles: Booking'

require 'open-uri' # consultar a la plataforma
require 'nokogiri' # formatear, parsear a html
require 'csv' # escribir y leer csv

# puntaje
# CSV.open('hoteles.csv', 'wb') do |csv|
#   csv << %w[id hotel puntaje link_hotel provincia]
# end

class Hotel
  attr_accessor :id, :nombre, :puntaje, :link, :provincia
  def initialize(id, nombre, puntaje, link, provincia)
    @id = id
    @nombre = nombre
    @puntaje = puntaje
    @link = link
    @provincia = provincia
  end

  def guardar(other_csv = 'hoteles.csv')
    CSV.open(other_csv, 'a') do |csv|
      csv << [@id, @nombre, @puntaje, @link, @provincia]
    end
  end
end

# Inputs
offset = 0
checkin =   '2023-02-01'
checkout =  '2023-02-03'
id = offset + 1

#Esmeraldas
# link = "https://www.booking.com/searchresults.en-gb.html?label=duc511jc-1FCAIoQUICZWNIM1gDaEGIAQGYAQm4AQfIAQzYAQHoAQH4AQ2IAgGoAgO4AqWU7Z0GwAIB0gIkOTNkY2I5NmYtMjRkZS00OGIzLWJkMDYtN2FjMzBhNGE1NDVh2AIG4AIB&sid=d937cab748728b6d0dd262df88420fff&aid=304142&ss=Esmeraldas&ssne=Esmeraldas&ssne_untouched=Esmeraldas&efdco=1&lang=en-gb&sb=1&src_elem=sb&src=searchresults&dest_id=13787&dest_type=region&checkin=#{checkin}&checkout=#{checkout}&group_adults=2&no_rooms=1&group_children=0&sb_travel_purpose=leisure&offset=#{offset}"
containe_c = ".d4924c9e74"
provincia_c = ".efdb2b543b"

#Quito
link = "https://www.booking.com/searchresults.en-gb.html?ss=Cuenca%2C+Ecuador&ssne=Quito&ssne_untouched=Quito&label=duc511jc-1FCAIoQUICZWNIM1gDaEGIAQGYAQm4AQfIAQzYAQHoAQH4AQ2IAgGoAgO4AqWU7Z0GwAIB0gIkOTNkY2I5NmYtMjRkZS00OGIzLWJkMDYtN2FjMzBhNGE1NDVh2AIG4AIB&sid=d937cab748728b6d0dd262df88420fff&aid=390156&lang=en-gb&sb=1&src_elem=sb&src=searchresults&dest_id=-926345&dest_type=city&ac_position=0&ac_click_type=b&ac_langcode=en&ac_suggestion_list_length=5&search_selected=true&search_pageview_id=ec4913011ef400b5&ac_meta=GhBlYzQ5MTMwMTFlZjQwMGI1IAAoATICZW46BEN1ZW5AAEoAUAA%3D&checkin=2023-02-01&checkout=2023-02-03&group_adults=2&no_rooms=1&group_children=0&sb_travel_purpose=leisure"

until offset == 75 do

  hotelesHTML = URI.open(link)
  datos = hotelesHTML.read
  parsed_content = Nokogiri::HTML(datos) # si pasa es porque la pagina si sigue estandares
  hoteles_container = parsed_content.css(containe_c)

  provincia = parsed_content.css('.efdb2b543b').inner_text.split(':')[0]
  puts(provincia)
  hoteles_container.css('.d20f4628d0').each do |hotel_post|
    nombre =   hotel_post.css('.e13098a59f').css('.fcab3ed991').inner_text.strip

    href_hotel = hotel_post.css('.a4225678b2').at_css('a')['href']

    puntaje = hotel_post.css('.d10a6220b4').inner_text.strip

    hotel = Hotel.new(id, nombre, puntaje, href_hotel, provincia)
    hotel.guardar
    id += 1

    puts("#{id}, #{nombre}, #{puntaje}, #{href_hotel}, #{provincia}")
  end

  offset += 25

end
