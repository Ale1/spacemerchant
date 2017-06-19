require_relative 'helpers'
require_relative 'models'
require_relative 'views'
  
class MerchantController
  attr_reader :current_sector
  
  def initialize
    @sectors = [Sector.new('Federation')]
    @current_sector = @sectors[0]
    @commands = []
    @reader = {
        'print_sectors' => /print\ssectors/i, 
        'add_sector' => /add\ssector\s\w+/i,
        'set_sector' => /change\ssector\sto\s\w+/i,
        'set_price' => /(\w+\s){1,4}[a-z]+\sis\s\d+\sCredits/i,
        'alien_to_arabic' => /how\smuch\sis\s(\w+\s)+\s?\?/i,
        'get_value' => /how\smany\sCredits\sis\s(\w+\s)+/i,
        'add_conversion' => /\D+\sis\s[A-Z]/i
      }
  end

  def run
    @commands = CommandParser.fetch_commands
    @commands.each { |command| execute(command) }
  end

  def add_sector(sector_name)
    raise MerchantError, "#{sector_name} coordinates are already in the Navigational Charts" if fetch_sectors.include? sector_name 
    sector = Sector.new(sector_name)
    @sectors << sector
  end
  
  def fetch_sectors
    @sectors.map {|sector| sector.name}
  end

  def set_sector(target)
    raise MerchantError, "#{target} is an Unknown Sector" unless fetch_sectors.include? target
    @current_sector = @sectors.select {|sector| sector.name == target}.first
  end

  def execute(command)
    begin
      case
        when command.match(@reader['print_sectors'])
          Viewer.print_sectors(fetch_sectors)

        when command.match(@reader['add_sector'])
          sector = command.split(" ").last
          add_sector(sector)
          Viewer.print_new_sector(sector)

        when command.match(@reader['set_sector'])
          sector = command.split(" ").last
          set_sector(sector)
          Viewer.print_sector(sector)
         
        when command.match(@reader['set_price'])
          sliced_input = command.split(" ").slice(0..-2)
          value = sliced_input.pop  
          sliced_input.pop
          metal = sliced_input.pop 
          quantity = sliced_input
          @current_sector.set_price(quantity,metal,value)
          Viewer.print_price(metal, @current_sector.name)

        when command.match(@reader['alien_to_arabic'])
          alien = command.split(" ").slice(3..-2)
          arabic = @current_sector.alien_to_arabic(alien)
          Viewer.print_arabic(alien,arabic)

        when command.match(@reader['get_value'])
          sliced_input = command.split(" ").slice(4..-2)
          metal = sliced_input.pop
          quantity = sliced_input
          credits = @current_sector.get_value(quantity,metal)
          Viewer.print_credits(quantity,metal,credits)

        when command.match(@reader['add_conversion'])
          key = command.split(" ")[0]
          value = command.split(" ")[2]
          @current_sector.add_conversion(key,value)
          Viewer.print_conversion(key,value)

        else raise MerchantError, "'#{command.strip}' is an unknown command" 
        end
      rescue Exception => e
        Viewer.print_error(e) 
      end
    end
  end


class CommandParser
    def self.fetch_commands
      commands = []
      if ARGV.empty?
        Dir["commands/*.txt"].each do |file|
          File.open(file,"r").each_line { |line|  commands << line }
        end
      elsif ARGV.first.match(/(.*spec\b)/)
         #do not run commands txt files
      else
        ARGV.each do |target|
          File.open("commands/#{target}.txt","r").each_line { |line|  commands << line }
        end
      end
      return commands
    end
  end



