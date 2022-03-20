#!/usr/bin/ruby

require "json"
timezone="Europe/Amsterdam"
json_from_file = File.read(ARGV[0])
fitbit = JSON.parse(json_from_file) 
thefile = ARGV[0]

if ARGV.length != 1
  puts "We need exactly one argument"
  exit
end

$totaldistance = 0 
def gettotaldistance(alldistances)
  alldistances.each do |key|
      if key['activity'] == "total"
        $totaldistance = key['distance']
    end
  end
end

thedate = fitbit['activities'][0]['startDate']
steps = fitbit['summary']['steps']
floors = fitbit['summary']['floors']
calories = fitbit['summary']['caloriesOut']
elevation = fitbit['summary']['elevation']
lightlyActiveMinutes = fitbit['summary']['lightlyActiveMinutes']
fairlyActiveMinutes = fitbit['summary']['fairlyActiveMinutes']
veryActiveMinutes = fitbit['summary']['veryActiveMinutes']
sedentaryMinutes = fitbit['summary']['sedentaryMinutes']
distances = fitbit['summary']['distances']

gettotaldistance(distances)

postTextComplete = "Fitbit Summary for "
postTextComplete.concat("#{thedate}\n\n")
newdate="#{thedate} 23:59:00 "
postTextComplete.concat("Total steps: #{steps}\n")
postTextComplete.concat("Floors climbed: #{floors}\n")
postTextComplete.concat("Calories burned: #{calories}\n")
postTextComplete.concat("Elevation gained: #{elevation} meters\n")
postTextComplete.concat("Traveled: #{$totaldistance} kilometers\n")
postTextComplete.concat("Sedentary minutes: #{sedentaryMinutes}\n")
postTextComplete.concat("Lightly active minutes: #{lightlyActiveMinutes}\n")
postTextComplete.concat("Fairly active minutes: #{fairlyActiveMinutes}\n")
postTextComplete.concat("Very active minutes: #{veryActiveMinutes}\n")
puts postTextComplete

return `echo "#{postTextComplete}" | dayone2 new -t fitbit summary -j Fitbit --date='#{newdate}' -z '#{timezone}'`;
