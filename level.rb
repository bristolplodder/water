require "json"
require "open-uri"
require 'soda'
require 'pony'
require 'rest_client'


client = SODA::Client.new({:domain => "XXXX", :username => "XXXX", :password => "XXXX", :app_token => "XXXX"})


result = RestClient.post "XXXX",{'PublicApiKey' => "XXXX",'ApiVersion' => 2}.to_json, :content_type => :json, :accept => :json

obj = JSON.parse(result)

headers = {SessionHeaderId:"#{obj['SessionHeaderId']}"}

response = RestClient.get "XXXX", headers

out = JSON.parse(response)


@alert = []

out.each do |z|

@alert << [z["name"],z["latitude"],z["longitude"], z['gaugeList'][0]['currentValue'],  z['gaugeList'][0]['currentValueTime']]


end

puts @alert

update = []
@alert.each do |x|

     update << {

"name" => x[0],
"latitude" => x[1],
"longitude" => x[2],
"currentValue" => x[3],
"currentValueTime" => x[4],
"location" => {
    "longitude" => x[2],
    "latitude" => x[1]
    }
}
 

end

   
  @response = client.put("XXXX", update)
  @response = client.post("XXXX", update)
