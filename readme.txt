
                                          ________.-._____
                               _____.----"--'-------------`-------._____
 ,------.______________.----._'=========================================`
 ]======================<|# |_)------- `----._____________.-----'
 `------.______________.----'[  ,--------/        `-'
          `-.---.-'    _____/__/___     /
        ____|   |-----'            `---<        ===== WELCOME CAPTAIN TO SPACEMERCHANT SHIP MODULE =====
       /||__|---|________             //             Licensed under the United Federation of Planets
       `------------._       _______ //
                      \        ---- //
                       |__________.-'

                        

Thank you for your purchase of SpaceMerchant ship module 1.0. 
This app will allow you to keep track of metal prices to ensure a profitable journey as you explore the far reaches of the galaxy. Warning: this civilian module does not include phasor targeting or shield optimisation;  Romulans are known to ambush metal traders regularly and caution should be exercised when trading in fringe star systems.  

Arquitecture:

  + Commandparser:  controller that captures the text commands and passes them to MerchantController.
  
  + MerchantController:  controller that reads and interprets the commands.  Will call on Sector and Translator objects accordingly. keeps track of what the current sector your ship is in.
  
  + Sector Model:  keeps track of metal prices in its own sector and performs metal valuations. also tracks the appropriate translator that should be called on this sector (for the reason that multiple-translators for each sector will be implemented in version 2.0.)

  + Translator Model:  keeps track of alien to roman conversions. and performs translations. 

  + viewer:  a simple view component to visualize text output on your terminal. (voice recognition has been banned since the Borg infiltrations of 2214) 



Features:
  + the default starting sector is "Federation".  You may add new sectors to your navigational charts.

  + You may head to a new sector that user has added.  Note that the new sector will have its own distinct alien language translation and commodity prices! (however, the universal roman numerals are consistent across sectors)

  + you may add and edit your own custom alien language translations.  E.g "blor is V". These are specific to the sector you are in.  

  + you may add and edit your metal prices.  E.g "blor Iron is 20 Credits".    

  + Commands are run from the txt files in the 'commands' folder. see usage for instructions.

  + unknown or erroneous commands will result in a output warning message.

  + output is printed directly to the terminal



Testing:
  -  to run Rspec tests and commands only, go to root folder (/spacemerchant), and run "rspec spec" to prevent reactor meltdowns. 

  - running "rspec" on its own will in addition execute all text files in the commands folder (test and non-test commands)

  - also, you may run individual test modules. go to '/spacemerchant/spec' and run e.g "rspec translation_spec.rb"



Usage:

  1) Go to /spacemerchant/commands folder

  2) create a new file with .txt extension.

  3) paste or type your commands inside this file.  One command per line, and be careful about spacing (see example.txt)

  4) you may run your commands by going to root folder and typing "ruby start.rb <name of your text file>". E.g: "ruby start.rb example"  (notice you DONT type .txt in this command)

  5) The Space merchant app will print your output to the screen.

  7) Alternatively, you may simply run "ruby start" to run ALL text files in the commands folder.




Valid commands:
  (see example.txt for additional guidance)

  add sector <sector name>   #=> will add sector to your merchant database

  print sectors  #=> will show available sectors

  change sector to <sector name> #=> will change your current sector (default is Federation)

  <alien glyph> is <roman glyph> #=> will add conversion to Translator (only to your current sector)

  <alien glyphs> <metal> is <number> Credits #=> will calculate the price of the metal in current sector

  how much is <alien glyphs> ? #=> will translate alien number to arabic number

  how many Credits is <alien glyph> <metal> #=> calculates value of this amount of metal in current sector



Setup:
 - only standard Ruby libraries (plus Rspec) is used. 
 - if Rspec is not running, got to root folder and try a "bundle install" first  
 