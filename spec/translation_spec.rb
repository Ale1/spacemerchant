
require_relative 'spec_helper.rb'

describe Translator do
  test_translator = Translator.new
  good_roman = {:R1=>['I'],:R2=>['I','I'],:R3=>['I','I','I'],:R4=>['I','V'], :R5 => ['V'], :R6=>['V','I'],
                :R8=>['V','I','I','I'], :R9=>['I','X'], :R10=>['X'], :R11=>['X','I'], :R15=>['X','V'],
                :R20=>['X','X']
              }
  
  bad_roman = {:R4=>['I','I','I','I'], :R7=>['I','I','I','X']}
  
  describe "#roman_to_arabic" do
    describe "it translates valid roman numerals to arabic" do

      it "should return '1' when #{good_roman[:R1]} is passed" do
         test_translator.roman_to_arabic(good_roman[:R1]).should == 1
      end

      it "should return '2' when #{good_roman[:R2]} is passed" do
         test_translator.roman_to_arabic(good_roman[:R2]).should == 2
      end

      it "should return '3' when #{good_roman[:R3]} is passed" do
        test_translator.roman_to_arabic(good_roman[:R3]).should == 3
      end
        
      it "should return '5' when #{good_roman[:R5]} is passed" do
        test_translator.roman_to_arabic(good_roman[:R5]).should == 5
      end

      it "should return '6' when '#{good_roman[:R6]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R6]).should == 6
      end

      it "should return '4' when '#{good_roman[:R4]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R4]).should == 4
      end

      it "should return '8' when '#{good_roman[:R8]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R8]).should == 8
      end
        
      it "should return '9' when '#{good_roman[:R9]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R9]).should == 9
      end 
        
      it "should return '10' when '#{good_roman[:R10]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R10]).should == 10
      end

      it "should return '11' when '#{good_roman[:R11]}' is passed" do
        test_translator.roman_to_arabic(['X','I']).should == 11
      end

      it "should return '15' when '#{good_roman[:R15]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R15]).should == 15
      end

      it "should return '20' when '#{good_roman[:R20]}' is passed" do
        test_translator.roman_to_arabic(good_roman[:R20]).should == 20
      end

      it "should return '25' when 'XXV' is passed" do
        test_translator.roman_to_arabic(['X','X','V']).should == 25
      end

      it "should return '30' when 'XXX' is passed" do
        test_translator.roman_to_arabic(['X','X','X']).should == 30
      end

      it "should return '14' when 'X I V' is passed" do 
        test_translator.roman_to_arabic(['X','I','V']).should == 14
      end	

      it "should return '19' when 'X I X' is passed" do 
        test_translator.roman_to_arabic(['X','I','X']).should == 19
      end

      it "should return '50' when 'L' is passed" do
        test_translator.roman_to_arabic(['L']).should == 50
      end

      it "should return '40' when 'XL' is passed" do
        test_translator.roman_to_arabic(['X','L']).should == 40
      end

      it "should return '48' when 'X L V I I' is passed" do
        test_translator.roman_to_arabic(['X','L','V','I','I','I']).should == 48
      end

      it "should return '49' when 'X L I X' is passed" do
        test_translator.roman_to_arabic(['X','L','I','X']).should == 49
      end
    end

    describe "it wont translate invalid roman numerals" do

      it "should raise RomanError when passed #{bad_roman[:R4]}" do
        expect{test_translator.roman_to_arabic(['I','I','I','I'])}.to raise_error(RomanError)
      end 

      it "should continue to pass errors for various invalid roman numerals" do
        bad_roman.values.each { |num| expect{test_translator.roman_to_arabic(num)}.to raise_error RomanError}
      end

      it "should not throw errors for various valid numerals" do 
        good_roman.values.each { |num| expect{test_translator.roman_to_arabic(num)}.to_not raise_error}
      end
    end
  end

  describe "#valid_roman?" do
    describe "it accepts valid roman numerals" do
      it "should return true for various valid numerals" do 
        good_roman.values.each { |num|  test_translator.valid_roman?(num).should be_true }
      end
        
      it "should return falsey for various invalid numerals" do
        bad_roman.values.each { |num|  test_translator.valid_roman?(num).should be_false }
      end

      it "should return falsey for an empty numeral" do 
        test_translator.valid_roman?([""]).should be_false
      end

      it "should return falsey for numerals with bad spacing" do 
        test_translator.valid_roman?(["I I   I"]).should be_false
      end
    end
    describe "#valid_base_roman?" do
      it "should return true for a valid base roman" do
        test_translator.valid_base_roman?('I').should be_true
      end
      it "should return false for a non-rooman numeral" do 
        test_translator.valid_base_roman?('A').should be_false
      end
      it "should return false for a roman numeral not in base constant" do
        test_translator.valid_base_roman?('VI').should be_false
      end
    end
  end

  describe "#add_conversion" do
      it "should add new conversion from alien to roman" do
        test_translator.add_conversion("uno",'I')
        test_translator.conversions['uno'].should == 'I'
    end
  end

 

  describe "#valid_alien? && alien to roman" do
      test_translator.add_conversion("uno",'I')
      test_translator.add_conversion("cinco",'V') 
    it "should return true for a valid single alien glyph" do
      test_translator.valid_alien?(['uno']).should be_true
    end
    it "should return true for many valid alien glyphs" do
      test_translator.valid_alien?(['cinco','uno','uno']).should be_true
    end
    it "should return false for invalid glyph" do 
      test_translator.valid_alien?(["hola!"]).should be_false
    end
    it "should retuen false for mix of valid and invalid glyphs" do
      test_translator.valid_alien?(['cinco','banana','uno']).should be_false
    end
    it "should return a roman translation" do 
      test_translator.alien_to_roman(['cinco','uno']).should == ['V','I']
    end
    it "should raise an AlienError when invalid glyphs are passed" do 
      expect{test_translator.alien_to_roman(['cinco','uno','tacos'])}.to raise_error AlienError
    end
  end
end





   	




