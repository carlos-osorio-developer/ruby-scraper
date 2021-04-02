require_relative '../lib/logic'
puts ''
puts 'Welcome to SummerOfCodeWithGoogle scraper'
puts ''
puts 'Press enter to continue'
gets
companies = []
5.times do |page|
  current_page = Scraper.new(page + 1)
  companies += current_page.into_array
end

puts "There are #{companies.length} organizations to filter"
puts ''
categories = %w[name]
categ_list = %w[website_url category contact_email contact_method description twitter_url topic_tags technology_tags
                proposal_tags ideas_list]
categ_select = nil
until categ_select == "\n"
  break if categ_list.empty?

  puts 'Please enter a number to add a category to scrap, press Enter whenever you are done'
  puts ''
  categ_list.each_with_index { |item, index| puts "Enter #{index + 1} to add \"#{item}\" category" }
  usr_selection = gets
  categ_select = case usr_selection
                 when "5\n" then 'precis'
                 when "\n" then "\n"
                 else usr_selection.chomp.to_i
                 end

  if categ_select.is_a?(Integer) && categ_select.between?(1, categ_list.length)
    categories << categ_list[categ_select - 1]
    categ_list.delete_at(categ_select - 1)
  elsif categ_select == "\n"
    next
  elsif categ_select == 'precis'
    categories << 'precis'
    categ_list.delete('description')
  else
    puts ''
    puts "Invalid value, please enter a number between 1 and #{categ_list.length}"
    puts ''
  end
end
