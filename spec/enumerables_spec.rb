# spec/enumerables_spec.rb
require './lib/enumerables'

RSpec.describe Enumerable do
  let(:numbers_array) { [1, 2, 3, 4, 5] }
  let(:number_range) { (1..5) }
  let(:words_array) { %w[hola hello goodbye never always] }

  describe '.my_each' do
    it 'executes a passed block for each element of an array' do
      myeach_array = []
      numbers_array.my_each { |x| myeach_array << x * 2 }
      expect(myeach_array).to eql([2, 4, 6, 8, 10])
    end

    it 'executes a passed block for each element of a range' do
      myeach_range = []
      number_range.my_each { |x| myeach_range << x * 2 }
      expect(myeach_range).to eql([2, 4, 6, 8, 10])
    end
  end

  describe '.my_each_with_index' do
    it 'calls a block with two arguments, the item and its index, for each item in the enumerator' do
      my_each_with_index_array = []
      numbers_array.my_each_with_index { |x, index| my_each_with_index_array << "#{x} index is #{index}" }
      expect(my_each_with_index_array).to eql(['1 index is 0', '2 index is 1',
                                               '3 index is 2', '4 index is 3', '5 index is 4'])
    end

    it 'returns an enumerable when no block is passed' do
      expect(numbers_array.my_each_with_index).to be_a(Enumerator)
    end
  end

  describe 'my_all?' do
    it 'returns true if the block never returns false or nil' do
      expect(numbers_array.my_all? { |x| x == 5 }).to_not eql(true)
    end

    it 'returns true if all of the elements inside an array correspond to the specified class' do
      expect(numbers_array.my_all?(Integer)).to eql(true)
    end
  end

  describe 'my_any?' do
    it 'returns true if the block ever returns a value other than false or nil' do
      expect(numbers_array.my_any? { |x| x == 5 }).to eql(true)
    end

    it 'returns true if it the block matches the regex at any point' do
      expect(words_array.my_any? { |x| x.match(/h/) }).to eql(true)
    end
  end

  describe 'my_none?' do
    it 'returns true if the block never returns true for all elements' do
      expect(numbers_array.my_none? { |x| x == 5 }).to_not eql(true)
    end

    it 'returns true if the block never returns true for all elements' do
      expect(numbers_array.my_none?(String)).to eql(true)
    end
  end

  describe 'my_count' do
    it 'returns the number of items in enum that are equal to argument passed in the block' do
      expect(numbers_array.my_count(&:even?)).to eql(2)
    end

    it 'counts the number of items in an array' do
      expect(numbers_array.my_count).to eql(5)
    end
  end

  describe 'my_map' do
    it 'returns a new array with the results of running block once for every element in enum' do
      mymap_array = []
      number_range.my_map { |x| mymap_array << x * x }
      expect(mymap_array).to eq([1, 4, 9, 16, 25])
    end

    it 'returns an enumerable if no block given' do
      expect(number_range.my_map).to be_a(Enumerator)
    end
  end
end
