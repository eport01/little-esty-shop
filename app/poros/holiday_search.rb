require './app/poros/holiday'
require './app/poros/holiday_service'

class HolidaySearch

  def holiday_info 
    service.holiday_information.map do |data|
      Holiday.new(data)
    end
  end
  def service 
    HolidayService.new 
  end


end

