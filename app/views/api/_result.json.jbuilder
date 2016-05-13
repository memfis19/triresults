json.place result.overall_place
json.time format_hours result.secs
json.last_name result.last_name
json.first_name result.first_name
json.bib result.bib
json.city result.city
json.state result.state
json.gender result.gender
json.gender_place result.gender_place

json.group result.group_name
json.group_place result.group_place
json.swim format_hours result.swim_secs
json.pace_100 format_minutes result.swim_pace_100
json.bike format_hours result.bike_secs
json.mph format_mph result.bike_mph
json.run format_hours result.run_secs
json.mmile format_minutes result.run_mmile
json.t1 format_minutes result.t1_secs
json.t2 format_minutes result.t2_secs

json.mmile format_minutes result.run_mmile
if result.race and result.race.id
  json.result_url "http://localhost:3000/api/races/#{result.race.id}/results/#{result.id}"
end
if result.racer and result.racer.id
  json.racer_url api_racer_url(result.racer.id)
end

