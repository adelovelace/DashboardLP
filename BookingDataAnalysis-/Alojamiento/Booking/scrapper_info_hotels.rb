
require 'selenium-webdriver'
require 'csv'


driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 60)

f1 = CSV.open('./Data/categories_hotels.csv', 'a')
f2 = CSV.open('./Data/surroundings_hotels.csv', 'a')

f1.puts(%w"id provincia categoria score")
f2.puts(%w"id provincia lugares distancia")


File.foreach("./Data/hoteles.csv", :encoding => 'UTF-8').with_index do |line, line_num|

  if line_num >= 284
    row = line.split(',', -1)
    link_hotel = row[4]
    puts("#{line_num}: ID #{row[0]}")
    puts(link_hotel)
    driver.navigate.to link_hotel

    #Categories
    begin
      wait.until{driver.find_elements(:class, "d46673fe81")[1].find_elements(:class, "d19ba76520")}.each { |category|
        category_name = category.find_element(:class,"d6d4671780").text.strip
        category_score = category.find_element(:class,"b8eef6afe1").text.strip

        f1.puts([row[0], row[5].strip, category_name, category_score])
      }
    rescue
      f1.puts([row[0], row[5].strip, "", ""])
    end

    #Surroundings
    wait.until{driver.find_element(:class, "f1bc79b259").find_elements(:class, "ae8177da1f")}.each { |category|
      place_name = category.find_element(:class,"aacd9d0b0a").text.strip
      place_distance = category.find_element(:class,"c90c0a70d3").text.strip

      f2.puts([row[0], row[5].strip, place_name, place_distance])
    }
  end
end

driver.close
f1.close
f2.close
