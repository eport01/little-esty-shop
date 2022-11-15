require 'httparty'
require './config/application'

class HolidayService
  
  def holiday_information 
    get_url("https://date.nager.at/api/v3/PublicHolidays/2022/US")
  end
  def get_url(url)
    response = HTTParty.get(url)
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end