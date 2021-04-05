require_relative '../lib/scraper'
require_relative '../lib/filter'
require_relative '../lib/classifier'
puts ''
puts 'Welcome to SummerOfCodeWithGoogle scraper'
puts ''
puts 'Press enter to continue'
gets
companies = []
comp_dictionary = []
categories = %w[name]
categ_list = %w[website_url category contact_email contact_method description twitter_url topic_tags technology_tags
                proposal_tags ideas_list]
categ_select = nil
quit_user = false
5.times do |page|
  current_page = Scraper.new(page + 1)
  companies += current_page.into_array
end

puts "There are #{companies.length} organizations to filter"
puts ''
until categ_select == "\n"
  break if categ_list.empty?

  puts 'Please enter a number to add a category to scrap, press Enter whenever you are done'
  puts ''
  categ_list.each_with_index { |item, index| puts "Enter #{index + 1} to add \"#{item}\" category" }
  usr_selection = gets
  categ_select = case usr_selection
                 when "\n" then "\n"
                 else usr_selection.chomp.to_i
                 end

  if categ_select.is_a?(Integer) && categ_select.between?(1, categ_list.length)
    categories << categ_list[categ_select - 1]
    categ_list.delete_at(categ_select - 1)
  elsif categ_select == "\n"
    next
  else
    puts ''
    puts "Invalid value, please enter a number between 1 and #{categ_list.length}"
    puts ''
  end
  categories[categories.length - 1] = 'precis' if categories.any? { |item| item == 'description' }
end

companies.each do |company|
  classifier = Classifier.new(company)
  comp_dictionary << classifier.dictionary(categories)
end

until %w[Y y].include?(quit_user)
  filtered_dictionary = []
  puts ''
  puts 'Add a keyword to search and filter the results'
  filter_keyword = gets.chomp
  filter_keyword1 = filter_keyword.downcase
  filter_keyword2 = filter_keyword.capitalize
  categories.each_with_index { |item, index| puts "Enter #{index + 1} to add \"#{item}\" category" }
  puts ''
  puts 'Add a category to search for the keyword, or press enter to search on every category'
  usr_filter_categ = gets
  filter_categ = usr_filter_categ == "\n" ? nil : usr_filter_categ.chomp.to_i
  if filter_categ.is_a?(Integer) && filter_categ.between?(1, categories.length)
    filter_categ = categories[filter_categ - 1]
    puts "Filtering for \"#{filter_keyword}\" in \"#{filter_categ}\" category"
    comp_dictionary.each do |company|
      boolean_filter = Filter.new(company)
      if boolean_filter.finder(filter_keyword1, filter_categ) || boolean_filter.finder(filter_keyword2, filter_categ)
        filtered_dictionary << company
      end
    end
  elsif filter_categ.nil?
    puts "Filtering for \"#{filter_keyword}\" in every category"
    comp_dictionary.each do |company|
      boolean_filter = Filter.new(company)
      filtered_dictionary << company if boolean_filter.finder(filter_keyword1) || boolean_filter.finder(filter_keyword2)
    end
  end
  if filtered_dictionary.empty?
    puts ''
    puts 'There are no results for this search'
  else
    filtered_dictionary.each_with_index do |filtered_company, index|
      puts ''
      puts "Result number #{index + 1}: "
      filtered_company.each do |key, value|
        puts "     #{key.to_s.capitalize} : " + value
      end
    end
  end
  puts ''
  puts 'Enter y/Y if you want to quit, press Enter if you want to do another search'
  quit_user = gets.chomp
end
