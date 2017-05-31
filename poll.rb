require "json"
require "open-uri"
require 'nokogiri'
require 'soda'
require 'rest_client'

client = SODA::Client.new({:domain => "XXXX", :username => "XXXX", :password => "XXXX", :app_token => "XXXX"})


@rows =[]

time = Time.new
yday = (time - 60*60*24).day 
puts yday


result = RestClient.post "XXXX",{'accountName' => 'XXXX','groupName' => 'XXXX'}

obj = JSON.parse(result)

obj.each_with_index do |zz,i|

  station_name = zz["StationName"]
  geo_location = zz["GeoLocation"]

  station = RestClient.post "XXXX",{'accountName' => 'XXXX','groupName' => 'XXXX','stationName' => station_name}

  station = JSON.parse(station)

@cumul_rain = 0
  station.each_with_index do |stn, ii|
    parameter_name = stn["Parameter"]
    channel_no = stn["Channel"]
    measurement_unit = stn["MeasurementUnit"]

    readings = RestClient.post "XXXX",{'accountName' => 'XXXX','groupName' => 'XXXX','stationName' => station_name, 'lastDays' => 2, 'parameterName' => parameter_name,'channel' => channel_no}

    readings = JSON.parse(readings)
    readings.each do |rr|   
      @event_time =  rr["EventTime"]
      @measurement =  rr["Measurement"]
      et = @event_time.to_s[8..9].to_i
       if et == yday
         if parameter_name != "Temp" && parameter_name != "AIRDIST"
          if parameter_name == "Rainfall"
            @cumul_rain = (@cumul_rain + @measurement).round(1)
          end
          @rows << [station_name, geo_location, @event_time, parameter_name, @measurement, measurement_unit, @cumul_rain]
         end
     end 
   end
  end
end


result = RestClient.post "XXXX",{'accountName' => 'XXXX','groupName' => 'XXXX'}

obj = JSON.parse(result)

obj.each_with_index do |zz,i|

  station_name = zz["StationName"]
  geo_location = zz["GeoLocation"]

  station = RestClient.post "XXXX",{'accountName' => 'XXXX','groupName' => 'XXXX','stationName' => station_name}

  station = JSON.parse(station)
@cumul_rain = 0
  station.each_with_index do |stn, ii|
    parameter_name = stn["Parameter"]
    channel_no = stn["Channel"]
    measurement_unit = stn["MeasurementUnit"]
    readings = RestClient.post "XXXX",{'accountName' => 'XXXX','groupName' => 'XXXX','stationName' => station_name, 'lastDays' => 2, 'parameterName' => parameter_name,'channel' => channel_no}

    readings = JSON.parse(readings)
    readings.each do |rr|
      @event_time =  rr["EventTime"]
      @measurement =  rr["Measurement"]
      et = @event_time.to_s[8..9].to_i
       if et == yday
         if parameter_name != "Temp" && parameter_name != "AIRDIST"
          if parameter_name == "Rainfall"
            @cumul_rain = (@cumul_rain + @measurement).round(1)
          end
          @rows << [station_name, geo_location, @event_time, parameter_name, @measurement, measurement_unit, @cumul_rain]
       end
     end
   end
  end
end



@update = []

@rows.each do |x|

     @update << {
    "station_name" => x[0],
    "geo_location" => x[1],
    "event_time" => x[2],
    "parameter_name" => x[3],
    "measurement" => x[4],
    "measurement_unit" => x[5],
    "cumul_rain" => x[6] 
    }
end

puts @update

@response = client.post("XXXX-XXXX", @update)

#USE WITH EXTREME CARE THIS CLEARS DATASET
#@response = client.put("2xe2-a3d5",{})
