require_relative '../lib/scraper'
require_relative '../lib/filter'
require_relative '../lib/classifier'

describe Scraper do
  let(:page) { Scraper.new(5) }
  describe '#into_array' do
    it 'returns an array with 10 elements for the last page' do
      expect(page.into_array.length).to eql(10)
    end

    it 'chops the first element of the array, which was empty' do
      expect(page.into_array[0]).to_not eql('')
    end
  end
end

describe Classifier do
  let(:test_array) { Classifier.new('"id":info1,"name":info2,"website_url":info3,"category":info4,') }
  describe '#extractor' do
    it 'extracts the information between two tags' do
      expect(test_array.extractor('id')).to eql('info1')
    end

    it 'returns an error if the input is not a string' do
      expect(test_array.extractor(['id'])).to_not eql('info1')
    end
  end

  describe '#dictionary' do
    it 'returns a hash with the extracted data' do
      expect(test_array.dictionary(%w[id name])).to eql({ id: 'info1', name: 'info2' })
    end

    it 'stores the keys of the hash as symbols' do
      expect(test_array.dictionary(%w[id name]).key('info1').is_a?(Symbol)).to_not eql(false)
    end
  end
end

describe Filter do
  let(:test_company) { Filter.new({ id: 'info1', name: 'info2' }) }
  describe '#finder' do
    it 'returns true if any value in the hash contains the given content' do
      expect(test_company.finder('info1')).to eql(true)
    end

    it 'returns false if none of the values in the hash contains the given content' do
      expect(test_company.finder('ruby')).to_not eql(true)
    end

    it 'returns true if the value in the given key contains the content' do
      expect(test_company.finder('info2', 'name')).to eql(true)
    end

    it 'returns false if the value in the given key does not contains the content' do
      expect(test_company.finder('info2', 'id')).to_not eql(true)
    end
  end
end
