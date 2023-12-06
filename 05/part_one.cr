file = File.new("./input")
content = file.gets_to_end
file.close

sections = content.split("\n\n")

seeds_raw = sections[0]

def map_with_mapping(input_value_raw, mapping_raw)
  input_value = input_value_raw.to_i64
  output_value = input_value
  mapping_raw.lines.each_with_index do |mapping_line, i|
    if i == 0
      next
    end

    parts = mapping_line.split(" ")

    source_start = parts[1].to_i64
    source_length = parts[2].to_i64
    destination_start = parts[0].to_i64

    source_end = source_start + source_length
    offset = destination_start - source_start

    if input_value >= source_start && input_value <= source_end
      output_value = input_value + offset
      break
    end
  end

  output_value
end

def map_full_chain_to_location(input_value_raw, sections)
  seed_to_soil_raw = sections[1]
  soil_to_fertilizer_raw = sections[2]
  fertilizer_to_water_raw = sections[3]
  water_to_light_raw = sections[4]
  light_to_temperature_raw = sections[5]
  temperature_to_humidity_raw = sections[6]
  humidity_to_location_raw = sections[7]

  soil = map_with_mapping(input_value_raw, seed_to_soil_raw)
  fertilizer = map_with_mapping(soil, soil_to_fertilizer_raw)
  water = map_with_mapping(fertilizer, fertilizer_to_water_raw)
  light = map_with_mapping(water, water_to_light_raw)
  temperature = map_with_mapping(light, light_to_temperature_raw)
  humidity = map_with_mapping(temperature, temperature_to_humidity_raw)
  location = map_with_mapping(humidity, humidity_to_location_raw)

  puts "Soil #{soil}"
  puts "Fertilizer #{fertilizer}"
  puts "Water #{water}"
  puts "Light #{light}"
  puts "Temperature #{temperature}"
  puts "Humidity #{humidity}"
  puts "Location #{location}"

  location
end

seeds = seeds_raw.gsub("seeds: ", "").split(" ")

locations = seeds.map {|x| map_full_chain_to_location(x, sections) }

puts locations.min
