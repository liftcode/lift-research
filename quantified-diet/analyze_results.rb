#!/usr/bin/ruby
require 'csv'

# diet_randomly_assigned,diet_randomly_assigned_name,accepted_assigned_diet,overridden_diet_id,eligible_diet_726,eligible_diet_722,eligible_diet_725,eligible_diet_586,eligible_diet_703,eligible_diet_569,eligible_diet_728,eligible_diet_723,eligible_diet_227208,eligible_diet_227209,eligible_diet_729,eligible_diet_727,gender_day0,energy_level_day0,who_live_with_day0,diet_include_meat_day0,diet_include_dairy_day0,diet_include_eggs_day0,diet_include_grains_day0,diet_include_candy_day0,diet_incude_soda_day0,diet_include_vegetables_day0,diet_includes_homecooked_day0,diet_include_ffood_day0,reasons_joined_weight_lost_percentage_day0,reasons_joined_health_day0,reasons_joined_energy_day0,reasons_joined_science_day0,confidence_day0,energy_level_day7,confidence_day7,energy_level_day14,diet_adherence_frequency_day14,confidence_day14,meat_freq_day14,nuts_freq_day14,pasta_freq_day14,legumes_freq_day14,vegetables_freq_day14,fruits_freq_day14,dairy_freq_day14,eggs_freq_day14,sweets_freq_day14,processed_foods_freq_day14,energy_level_day21,diet_adherence_frequency_day21,confidence_day21,meat_freq_day21,nuts_freq_day21,pasta_freq_day21,legumes_freq_day21,vegetables_freq_day21,fruits_freq_day21,dairy_freq_day21,eggs_freq_day21,sweets_freq_day21,processed_foods_freq_day21,stepped_on_scale_day28,height_feet_day28,height_inches_day28,energy_level_day28,diet_adherence_frequency_day28,meat_freq_day28,nuts_freq_day28,pasta_freq_day28,legumes_freq_day28,vegetables_freq_day28,fruits_freq_day28,dairy_freq_day28,eggs_freq_day28,sweets_freq_day28,processed_foods_freq_day28,ate_regularly_breakfast_day28,ate_regularly_lunch_day28,ate_regularly_dinner_day28,ate_regularly_snack_day28,ate_regularly_dessert_day28,hours_sleep_regularly_day28,exercise_frequency_day28,exercise_relative_to_norm_day28,kept_track_of_food_day28,restricted_portions_day28,counted_calories_day28,stopped_eating_day28,time_spent_eating_lunch_day28,would_do_diet_again_day28,would_recommend_diet_day28,n_diets_selected,n_control_diets_selected_,diet_actually_on,weight_lost_percentage_day7,weight_lost_percentage_day14,weight_lost_percentage_day21,weight_lost_percentage_day28

def puts_tabs(array)
  result = array.map do |item|
    if item.kind_of?(Float)
      sprintf("%10.3f", item)
    elsif item.kind_of?(Integer)
      sprintf("%10d", item)
    else 
      sprintf("%37s", item)
    end
  end
  puts result.join(" | ")
end

diet_names = ["The Calorie Counting Diet", "The Whole Foods Diet", "Slow-Carb Diet™ from The 4-Hour Body", "The No Sweets Diet", "The Mindful Eating Diet", "The DASH Diet", "The Paleo Diet", "The Gluten-Free Diet"]
csv = CSV.read("quantified.diet.results.csv", :headers => true)

experiment = []
observation = []
(0..csv.size - 1).to_a.each do |index|
  if csv[index]["weight_lost_percentage_day7"] and weight_loss = csv[index]["weight_lost_percentage_day7"].to_f and weight_loss.abs < 0.2 
    csv[index]["week_1_loss"] = weight_loss
  end

  if csv[index]["weight_lost_percentage_day14"] and weight_loss = csv[index]["weight_lost_percentage_day14"].to_f and weight_loss.abs < 0.2 
    csv[index]["week_2_loss"] = weight_loss
  end

  if csv[index]["weight_lost_percentage_day21"] and weight_loss = csv[index]["weight_lost_percentage_day21"].to_f and weight_loss.abs < 0.2 
    csv[index]["week_3_loss"] = weight_loss
  end

  if csv[index]["weight_lost_percentage_day28"] and weight_loss = csv[index]["weight_lost_percentage_day28"].to_f and weight_loss.abs < 0.2 
    csv[index]["week_4_loss"] = weight_loss
  end

  next unless csv[index]["week_1_loss"] or csv[index]["week_2_loss"] or csv[index]["week_3_loss"] or csv[index]["week_4_loss"]
  experiment << csv[index]
  if csv[index]["overridden_diet_id"]
    observation << csv[index]
  end
end

puts "Number of complete experimental records: " + experiment.size.to_s
puts "Number of complete observational records: " + observation.size.to_s
#################################

puts "\n\n\nPercentage of people who lost weight by week."
diet_names.each do |diet|
  experiment_for_diet = experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet}

  puts_tabs( [diet,
        experiment_for_diet.size,
        experiment_for_diet.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0}.size / experiment_for_diet.find_all{|a| a["week_1_loss"]}.size.to_f,
        experiment_for_diet.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0}.size / experiment_for_diet.find_all{|a| a["week_2_loss"]}.size.to_f,
        experiment_for_diet.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0}.size / experiment_for_diet.find_all{|a| a["week_3_loss"]}.size.to_f,
        experiment_for_diet.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0}.size / experiment_for_diet.find_all{|a| a["week_4_loss"]}.size.to_f])
end

#################################

puts "\n\n\nExperimental group vs. Observational group"
people_who_completed_week4_count = experiment.find_all{|a| a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size
observation_people_who_completed_week4_count = observation.find_all{|a| a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size

puts_tabs ["Success rate by week for experiment ",
        experiment.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / people_who_completed_week4_count.to_f,
        experiment.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / people_who_completed_week4_count.to_f,
        experiment.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / people_who_completed_week4_count.to_f,
        experiment.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / people_who_completed_week4_count.to_f]

puts_tabs ["Success rate by week for observation",
        observation.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / observation_people_who_completed_week4_count.to_f,
        observation.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / observation_people_who_completed_week4_count.to_f,
        observation.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / observation_people_who_completed_week4_count.to_f,
        observation.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size / observation_people_who_completed_week4_count.to_f]


#################################
# Average weight loss by week by diet
# diet, week 1, week2, week3, week4

puts "\n\n\nAverage weight loss by week by diet"
puts "diet", "week 1, week 2, week 3, week 4"
diet_names.each do |diet|
  #experiment_for_diet = experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]} 
  experiment_for_diet = experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet}

  puts_tabs [diet,
        experiment_for_diet.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0}.inject(0){|sum,a| sum += a["week_1_loss"].to_f} / experiment_for_diet.find_all{|a| a["week_1_loss"]}.size.to_f,
        experiment_for_diet.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0}.inject(0){|sum,a| sum += a["week_2_loss"].to_f} / experiment_for_diet.find_all{|a| a["week_2_loss"]}.size.to_f,
        experiment_for_diet.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0}.inject(0){|sum,a| sum += a["week_3_loss"].to_f} / experiment_for_diet.find_all{|a| a["week_3_loss"]}.size.to_f,
        experiment_for_diet.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0}.inject(0){|sum,a| sum += a["week_4_loss"].to_f} / experiment_for_diet.find_all{|a| a["week_4_loss"]}.size.to_f]
end

people_who_completed_week4_count = experiment.find_all{|a| a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.size
puts_tabs ["Total",
        experiment.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.inject(0.0){|sum,a| sum += a["week_1_loss"].to_f} / people_who_completed_week4_count.to_f,
        experiment.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.inject(0.0){|sum,a| sum += a["week_2_loss"].to_f} / people_who_completed_week4_count.to_f,
        experiment.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.inject(0.0){|sum,a| sum += a["week_3_loss"].to_f} / people_who_completed_week4_count.to_f,
        experiment.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0 && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]}.inject(0.0){|sum,a| sum += a["week_4_loss"].to_f} / people_who_completed_week4_count.to_f]


################################
# Average weight loss by gender for people who completed all four surveys
# diet/total male/female, week1, week2, week3, week4

puts "\n\n\nAverage weight loss by gender by diet for people who completed all surveys"
# diet/total male/female, week1, week2, week3, week4

["0", "1"].each do |sex|
  experiment_for_sex = experiment.find_all{|a| a["gender_day0"] == sex}
  puts_tabs [{"0" => "female", "1" => "male"}[sex],
        experiment_for_sex.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0}.inject(0){|sum,a| sum += a["week_1_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_1_loss"]}.size.to_f,
        experiment_for_sex.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0}.inject(0){|sum,a| sum += a["week_2_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_2_loss"]}.size.to_f,
        experiment_for_sex.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0}.inject(0){|sum,a| sum += a["week_3_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_3_loss"]}.size.to_f,
        experiment_for_sex.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0}.inject(0){|sum,a| sum += a["week_4_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_4_loss"]}.size.to_f]
end
experiment_for_sex = experiment.find_all{|a| a["gender_day0"]}
puts_tabs ["total",
        experiment_for_sex.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0}.inject(0){|sum,a| sum += a["week_1_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_1_loss"]}.size.to_f,
        experiment_for_sex.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0}.inject(0){|sum,a| sum += a["week_2_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_2_loss"]}.size.to_f,
        experiment_for_sex.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0}.inject(0){|sum,a| sum += a["week_3_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_3_loss"]}.size.to_f,
        experiment_for_sex.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0}.inject(0){|sum,a| sum += a["week_4_loss"].to_f} / experiment_for_sex.find_all{|a| a["week_4_loss"]}.size.to_f]


#################################
# Average weight loss by starting condition
# include meat, include_dairy, include_eggs, include_grains, include_candy, include_soda, include_vegetables, includes_homecooked, include_ffod

puts "\n\n\nAverage weight loss by starting condition"
%q{diet_include_meat_day0,diet_include_dairy_day0,diet_include_eggs_day0,diet_include_grains_day0,diet_include_candy_day0,diet_incude_soda_day0,diet_include_vegetables_day0,diet_includes_homecooked_day0,diet_include_ffood_day0}.split(",").each do |start|
  experiment_for_start = experiment.find_all{|a| a[start] == "1"}
  puts_tabs [start,
        experiment_for_start.find_all{|a| a["week_1_loss"] and a["week_1_loss"] < 0}.inject(0){|sum,a| sum += a["week_1_loss"].to_f} / experiment_for_start.find_all{|a| a["week_1_loss"]}.size.to_f,
        experiment_for_start.find_all{|a| a["week_2_loss"] and a["week_2_loss"] < 0}.inject(0){|sum,a| sum += a["week_2_loss"].to_f} / experiment_for_start.find_all{|a| a["week_2_loss"]}.size.to_f,
        experiment_for_start.find_all{|a| a["week_3_loss"] and a["week_3_loss"] < 0}.inject(0){|sum,a| sum += a["week_3_loss"].to_f} / experiment_for_start.find_all{|a| a["week_3_loss"]}.size.to_f,
        experiment_for_start.find_all{|a| a["week_4_loss"] and a["week_4_loss"] < 0}.inject(0){|sum,a| sum += a["week_4_loss"].to_f} / experiment_for_start.find_all{|a| a["week_4_loss"]}.size.to_f]
end


#################################
# Average drop off by diet 
# diet / total, percentage who fill out week 4
puts "\n\n\n% completion by diet"

diet_names.each do |diet|
  experiment_for_diet = experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]} 
  puts_tabs [diet,
        experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet && a["weight_lost_percentage_day28"]}.size / experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet}.size.to_f]
end

#################################
# Adherence by diet
puts "\n\n\nAdherence by diet"
puts "diet, size, vl %, l %, m %, h %, vh %"
diet_names.each do |diet|
  experiment_for_diet = experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet and a["diet_adherence_frequency_day28"]}
  puts_tabs [ diet,
         experiment_for_diet.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "1"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "2"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "3"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "4"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "5"}.size / experiment_for_diet.size.to_f,  
       ]
end
experiment_for_diet = experiment.find_all{|a| a["diet_adherence_frequency_day28"]}
puts_tabs [ "total",
         experiment_for_diet.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "1"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "2"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "3"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "4"}.size / experiment_for_diet.size.to_f,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "5"}.size / experiment_for_diet.size.to_f,  
       ]
puts_tabs [ "total counts",
         experiment_for_diet.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "1"}.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "2"}.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "3"}.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "4"}.size,
         experiment_for_diet.find_all{|a| a["diet_adherence_frequency_day28"] == "5"}.size,  
       ]
  
  #################################"
# Weight loss by behavior frequency
puts "\n\n\nWeight loss by behavior frequency"
puts "food, 1, 2, 3, 4, 5"
["diet_adherence_frequency_day28", "meat_freq_day28", "nuts_freq_day28", "pasta_freq_day28", "legumes_freq_day28", "vegetables_freq_day28", "fruits_freq_day28", "dairy_freq_day28", "eggs_freq_day28", "sweets_freq_day28", "processed_foods_freq_day28", "kept_track_of_food_day28", "restricted_portions_day28", "counted_calories_day28", "stopped_eating_day28"].each do |food|
  experiment_for_food = experiment.find_all{|a| a["weight_lost_percentage_day28"] and a[food]}
  puts_tabs [ food,
         experiment_for_food.find_all{|a| a[food] == "1"}.inject(0){|sum, a| sum += a["week_4_loss"].to_f} / experiment_for_food.find_all{|a| a[food] == "1"}.count.to_f,
         experiment_for_food.find_all{|a| a[food] == "2"}.inject(0){|sum, a| sum += a["week_4_loss"].to_f} / experiment_for_food.find_all{|a| a[food] == "2"}.count.to_f,
         experiment_for_food.find_all{|a| a[food] == "3"}.inject(0){|sum, a| sum += a["week_4_loss"].to_f} / experiment_for_food.find_all{|a| a[food] == "3"}.count.to_f,
         experiment_for_food.find_all{|a| a[food] == "4"}.inject(0){|sum, a| sum += a["week_4_loss"].to_f} / experiment_for_food.find_all{|a| a[food] == "4"}.count.to_f,
         experiment_for_food.find_all{|a| a[food] == "5"}.inject(0){|sum, a| sum += a["week_4_loss"].to_f} / experiment_for_food.find_all{|a| a[food] == "5"}.count.to_f]
end


#################################
# Would recommend or do again
# diet, would recommend, would do again
puts "\n\n\nWould recommend or do diet again. (diet, recommend, do again)"

diet_names.each do |diet|
  experiment_for_diet = experiment.find_all{|a| a["diet_randomly_assigned_name"] == diet && a["weight_lost_percentage_day28"] && a["weight_lost_percentage_day7"] && a["weight_lost_percentage_day14"] && a["weight_lost_percentage_day21"]} 
  puts_tabs [diet,
        experiment_for_diet.find_all{|a| a["would_recommend_diet_day28"] == "Yes"}.size.to_f / experiment_for_diet.size.to_f,
        experiment_for_diet.find_all{|a| a["would_do_diet_again_day28"] == "Yes"}.size.to_f / experiment_for_diet.size.to_f]
end

