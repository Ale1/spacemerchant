
class Sector 
  attr_reader :metals, :name, :translator
  
  def initialize(sector_name)
    @name = sector_name
    @translator = Translator.new
    @metals = {}
  end

  def conversions
    @translator.conversions
  end

  def add_conversion(key,value)
    @translator.add_conversion(key,value)
  end

  def alien_to_arabic(array)
    @translator.alien_to_arabic(array)
  end

  def set_price(quantity,metal,value)
    @metals[metal] = (value.to_f / @translator.alien_to_arabic(quantity).to_i)
  end

  def get_value(quantity, metal)
    raise PriceError, "'#{metal}' type not found in Merchant Records" unless @metals.include?(metal) 
    value = (@metals[metal] * @translator.alien_to_arabic(quantity)).to_i
  end  
end


class Translator
  attr_reader :conversions, :romans
  
  def initialize
    @romans = ROMANS
    @conversions = {}
  end

  def add_conversion(key,value)
     raise RomanError, "'#{value}'' cannot be used as a base roman numeral" unless valid_base_roman?(value)
     @conversions[key] = value
  end

  def alien_to_arabic(array)
    roman =  alien_to_roman(array)
    arabic = roman_to_arabic(roman)
  end

  def valid_base_roman?(string)
    ROMANS.keys.include?(string)
  end

  def valid_roman?(array)
    (array.join.match(/^(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$/) && !array.first.empty?)
     #can expand to ^(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$ to include hundreds.
  end

  def valid_alien?(array)
    (array - @conversions.keys).size == 0
  end

  def roman_to_arabic(array)
    raise RomanError, "'#{array.join}' is an invalid roman numeral" unless valid_roman?(array)
    numbers= array.inject([]) { |result, char| result << @romans[char] }
    numbers_adj_for_negatives = numbers.each_with_index.map { |num,i| num < (numbers[i+1] || 0) ? num* -1 : num }
    numbers_adj_for_negatives.inject(:+)
  end

  def alien_to_roman(array)
    raise AlienError, "'#{array.join(" ")}' is an invalid number" unless valid_alien?(array)
    roman = array.inject([]) { |result, char| result << conversions[char] }
  end
end
