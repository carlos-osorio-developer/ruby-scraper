class Classifier
  def initialize(company)
    @raw_data = company
    @company_categories = %w[id name website_url category contact_email mailing_list irc_channel tag_line precis
                             description tags primary_open_source_license image_url image_bg_color gplus_url
                             twitter_url blog_url application_instructions topic_tags technology_tags proposal_tags
                             ideas_list contact_method program_year]
  end

  def dictionary(keywords)
    'Please enter an array' unless keywords.is_a? Array

    hash = {}
    keywords.each do |keyword|
      hash[keyword.to_sym] = extractor(keyword)
    end
    hash
  end

  private

  def extractor(category)
    return 'Please enter a string' unless category.is_a? String

    index = @company_categories.index(category)
    keyword = "\"#{@company_categories[index]}\":"
    keyword_index = @raw_data.index(keyword) + keyword.length
    next_keyword = "\"#{@company_categories[index + 1]}\":"
    next_keyword_index = @raw_data.index(next_keyword) - 2
    @raw_data[keyword_index..next_keyword_index]
  end
end
