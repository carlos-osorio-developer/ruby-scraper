class Filter
  def initialize(company)
    @company = company
    @filter = false
  end

  def finder(keyword, category = nil)
    if category.nil?
      @filter = true if @company.any? { |_key, value| value.include?(keyword) }
    elsif @company.any? { @company[category.to_sym].include?(keyword) }
      @filter = true
    end
    @filter
  end
end
