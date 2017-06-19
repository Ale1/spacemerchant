require_relative 'spec_helper.rb'

module SpaceMerchant
  describe Sector do 
    test_sector = Sector.new("Fengeri")
  	describe "#initialize" do 
      it "should intialize an instance of class Sector with name attribute and a translator" do
      test_sector.class.should == Sector
      test_sector.name.should == "Fengeri"
      test_sector.translator.class.should == Translator
      end 
  	end

  	describe "sector should able to manage translations and pricing tasks" do
      test_sector.translator.add_conversion("uno",'I')
      test_sector.translator.add_conversion("cinco",'V')
      test_sector.translator.add_conversion("diez",'X')

      
      describe "#set_price" do
        it "should modify metals attribute when a new metal is passed" do
          test_sector.set_price(['uno'],'lead',1) 
          test_sector.metals['lead'].should == 1
        end
        it "should set a metal price when passed valid arguments" do
          test_sector.set_price(['cinco'],"Gold",100).should == 20
        end
        it "should mantain decimal integrity" do 
          test_sector.set_price(['diez'],"Iron",11).should == 1.1
        end
        it "should return an AlienError when passed a bad quantity" do 
          expect{test_sector.set_price(['queso'],"Silver",50)}.to raise_error AlienError
        end
         it "should return an AlienError when passed an empty quantity" do 
          expect{test_sector.set_price([''],"Silver",50)}.to raise_error AlienError
        end
        it "should modify the price of an existing log" do
          test_sector.set_price(['diez'],"Kryptonite",100)
          test_sector.set_price(['diez'],"Kryptonite",200)
          test_sector.metals['Kryptonite'].should == 20
        end
      end

      describe "#get_value" do
        test_sector.set_price(['uno'],'Dirt',10)
        it "should return the value of a metal when given valid inputs" do
          test_sector.get_value(['uno'],'Dirt').should == 10
        end
        it "should raise UnknownPrice Error if metal is not found" do 
          expect{test_sector.get_value(['uno'],'Hamburgers')}.to raise_error PriceError
        end 
      end
    end
  end
end