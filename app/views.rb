
class Viewer
  private
  def self.print_sectors(sectors)
    p "Current sectors in Datalogs: #{sectors.join(", ")}" 
  end

  def self.print_new_sector(sector)
    p "#{sector.capitalize} sector has been added to star chart."
  end

  def self.print_sector(sector)
    p "Captain, course has been set for #{['alpha','beta','gamma','delta','epsilon'].sample} quadrant in #{sector} sector"
  end

  def self.print_credits(quantity,metal,credits)
    p "Engineering reports that #{quantity.join(" ")} #{metal} is worth #{credits} Credits"
  end

  def self.print_arabic(quantity,arabic)
    p "#{quantity.join(" ")} is #{arabic}"
  end

  def self.print_price(metal, sector)
    p "#{metal} price has been updated in #{sector} sector"
  end

  def self.print_error(e)
    p "#{e.class} >> #{e.message}"
  end

  def self.print_conversion(key,value)
    p "conversion added: #{key} => #{value}"
  end
end