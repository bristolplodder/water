require "json"
require "open-uri"
require 'soda'
require 'pony'



client = SODA::Client.new({:domain => "XXXX", :username => "XXXX", :password => "XXXX", :app_token => "XXXX"})


result = JSON.parse(open("XXXX").read)


puts result

@alert = []
@count = 0


result.each do |a|

if ((a["Center"]["Latitude"]>51.4 && a["Center"]["Latitude"]<51.6)&& (a["Center"]["Longitude"]>-2.7 && a["Center"]["Longitude"]<-2.5))


@alert << [a["FloodAreaID"],a["FloodAreaSetID"],a["FloodAlertSetID"],a[ "AreaCode"],a["AreaDescription"],a["AreaFloodlineQuickdialCode"],a["Region"],a["SubRegion"],a["Center"]["Latitude"],a["Center"]["Longitude"],a["Altitude"],a["FloodType"],a["Severity"],a["WarningKey"],a["Raised"],a["SeverityChanged"],a["MessageChanged"],a["MessageEnglish"],a["MessageWelsh"],a["FormattedTimePassed"],a["ID"=>5455501]]



puts a["Center"]["Latitude"]
puts "***"


if (@count < 1)
Pony.mail(:to => 'XXXX',:from => 'XXXX',:via => :sendmail,:subject => 'Flood alert', :body => 'a flood alert has been issued')
end

@count =+1

end
end

update = []
@alert.each do |x|

     update << {

"FloodAreaID" => x[0],
"FloodAreaSetID" => x[1],
"FloodAlertSetID" => x[2],
"AreaCode" => x[3],
"AreaDescription" => x[4],
"AreaFloodlineQuickdialCode" => x[5],
"Region" => x[6],
"SubRegion" => x[7],
"Centre_Latitude" => x[8],
"Centre_Longitude" => x[9],
"Altitude" => x[10],
"FloodType" => x[11],
"Severity" => x[12],
"WarningKey" => x[13],
"Raised" => x[14],
"SeverityChanged" => x[15],
"MessageChanged" => x[16],
"MessageEnglish" => x[17],
"MessageWelsh" => x[18],
"FormattedTimePassed" => x[19],
"ID" => x[20],
"location" => {
    "longitude" => x[9],
    "latitude" => x[8]
    }
}
 

end

puts update
    
#  @response = client.put("v948-7dkv", update)
  @response = client.post("XXXX", update)
