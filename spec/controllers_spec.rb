require_relative 'spec_helper.rb'

  testcom = {
              :T1=>'glob is I', :T2=>'prok is V', :T3=>'pish is X', :T4=>'tegj is L',
              :T5=>'glob glob Silver is 34 Credits', :T6=>'glob prok Gold is 57800 Credits', :T7=> 'glob Iron is 10 Credits',
              :T8=>'how much is pish tegj glob glob ?', 
              :T9=>'how many Credits is glob prok Silver ?', :T10=>'how many Credits is glob prok Gold ?', :T11=>'how many Credits is glob prok Iron ?',
              :T12=>'how much wood does a wood-chuck chuck ?'
            }

  output = { :T8=> "pish tegj glob glob is 42",
             :T9=>"Engineering reports that glob prok Silver is worth 68 Credits",
             :T10=>"Engineering reports that glob prok Gold is worth 57800 Credits",
             :T11=>"Engineering reports that glob prok Iron is worth 40 Credits",
             :T12=>"MerchantError >> 'how much wood does a wood-chuck chuck ?' is an unknown command"
           }

  describe 'MerchantController'  do
  	merchant= MerchantController.new
  	describe "#initialize" do
  	  it "should create create a new instance of MerchantController" do
  		  merchant.class.should  == MerchantController
  	  end
      it "should create a default current sector for new instances of MerchantController" do
  		  merchant.current_sector.class.should == Sector
  	  end 
  	end

  	describe "#add_sector & #fetch_sectors" do 
  	  it "should allow adding of sectors & and they should be stored in the instance" do
        merchant.add_sector("Orion")
  	    merchant.fetch_sectors.should include("Orion")
  	  end
      it "should prevent duplicate sectors from being added" do 
        expect{merchant.add_sector("Elachi"); merchant.add_sector("Elachi")}.to raise_error MerchantError
      end
      it "should fetch sectors" do 
        merchant.fetch_sectors.should include("Federation","Orion","Elachi")
      end 
      it "should be able to change current sector" do
        merchant.set_sector("Elachi")
        merchant.current_sector.name.should == "Elachi"
      end
      it "should throw and error when setting current sector to an unknown sector" do 
        expect{merchant.set_sector("Cucamonga")}.to raise_error MerchantError
      end 
    end

    describe "ability to execute text commands" do
      describe "can add conversions through text commands" do
        it "should execute #{testcom[:T1]} correctly" do
          merchant.execute(testcom[:T1])
          merchant.current_sector.conversions[testcom[:T1].split(" ").first].should == testcom[:T1].split(" ").last
        end
        it "should execute #{testcom[:T2]} correctly" do
          merchant.execute(testcom[:T2])
          merchant.current_sector.conversions[testcom[:T2].split(" ").first].should == testcom[:T2].split(" ").last
        end
        it "should execute #{testcom[:T3]} correctly" do
          merchant.execute(testcom[:T3])
          merchant.current_sector.conversions[testcom[:T3].split(" ").first].should == testcom[:T3].split(" ").last
        end
        it "should execute #{testcom[:T4]} correctly" do
          merchant.execute(testcom[:T4])
          merchant.current_sector.conversions[testcom[:T4].split(" ").first].should == testcom[:T4].split(" ").last
        end
      end

      describe "can handle given test input and output" do
        it "should execute #{testcom[:T5]} without any errors correctly" do 
          expect{merchant.execute(testcom[:T5])}.to_not raise_error
        end
        it "should execute #{testcom[:T6]}, increasing metal count" do 
          expect{merchant.execute(testcom[:T6])}.to change{merchant.current_sector.metals.count}.from(1).to(2)
        end
        it "should execute #{testcom[:T7]}, setting price of the metal correctly" do 
          merchant.execute(testcom[:T7])
          merchant.current_sector.metals[testcom[:T7].split(" ")[-4]].should == testcom[:T7].split(" ")[-2].to_i
        end

        it "should execute #{testcom[:T8]}, returning test output" do
          merchant.execute(testcom[:T8]).should == output[:T8]
        end
        it "should execute #{testcom[:T9]}, returning test output" do
         merchant.execute(testcom[:T9]).should == output[:T9]
        end 
        it "should execute #{testcom[:T10]}, returning test output" do
          merchant.execute(testcom[:T10]).should == output[:T10]
        end
        it "should execute #{testcom[:T11]}, returning test output" do
          merchant.execute(testcom[:T11]).should == output[:T11]
        end
        it "should execute #{testcom[:T12]}, returning test output" do
          merchant.execute(testcom[:T12]).should == output[:T12]
        end
      end 
    end
  end
