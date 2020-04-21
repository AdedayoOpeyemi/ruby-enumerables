# spec/enumerables_spec.rb
require_relative '../lib/enumerables.rb'

RSpec.describe Enumerable do
  let(:numbers_array) { [1, 2, 3, 4, 5] }
  let(:nil_and_numbers_array) { [nil, 2, nil, 4, 5] }
  let(:number_range) { (1..5) }
  let(:words_array) { %w[hola hello goodbye never always] }
  let(:a_proc) { proc { |sum, n| sum + n } }
  let(:another_proc) { proc { |x| x + 1 } }

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

    it 'returns enumerable whuen not passed a block' do
      expect(numbers_array.my_each).to be_a(Enumerator)
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

    it 'returns enumerable whuen not passed a block' do
      expect(numbers_array.my_each_with_index).to be_a(Enumerator)
    end
  end

  describe 'my_all?' do
    context 'A block is given' do
      it 'returns true if the block never returns false or nil' do
        expect(numbers_array.my_all? { |x| x == 5 }).to_not eql(true)
      end
    end

    context 'No block given' do
      it 'returns true if all of the elements inside an array correspond to the specified class' do
        expect(numbers_array.my_all?(Integer)).to eql(true)
      end

      it 'returns true if all of the elements inside an array are true i.e not nil or false' do
        expect(nil_and_numbers_array.my_all?).to_not eql(true)
      end

      it 'returns false if not all of the elements of the array match the regular expresion' do
        expect(words_array.my_all? { |x| x.match(/h/) }).to eql(false)
      end

      it 'returns false if not all of the elements of the array match the argument passed' do
        expect(numbers_array.my_all?(2)).to eql(false)
      end
    end
  end

  describe 'my_any?' do
    context 'A block is given' do
      it 'returns true if the block ever returns a value other than false or nil' do
        expect(numbers_array.my_any? { |x| x == 5 }).to eql(true)
      end
    end

    context 'No block given' do
      it 'returns true if any of the elements in the array belong to the class passed as argument' do
        expect(nil_and_numbers_array.my_any?(Integer)).to eql(true)
      end

      it 'returns true if any of the elements in the array are not nil or false' do
        expect(nil_and_numbers_array.my_any?).to eql(true)
      end

      it 'returns true if any of the elements in the array match the argument passed' do
        expect(nil_and_numbers_array.my_any?(5)).to eql(true)
      end

      it 'returns true if it the block matches the regex at any point' do
        expect(words_array.my_any? { |x| x.match(/h/) }).to eql(true)
      end
    end
  end

  describe 'my_none?' do
    context 'A block is given' do
      it 'returns true if the block never returns true for all elements' do
        expect(numbers_array.my_none? { |x| x == 5 }).to_not eql(true)
      end
    end

    context 'No block given' do
      it 'returns false if any of the elements in the array matches the argument passed' do
        expect(numbers_array.my_none?(5)).to eql(false)
      end

      it 'returns true if none of the elements in the array is false' do
        expect(numbers_array.my_none?(nil)).to eql(true)
      end

      it 'returns true if none of the elements in the array match the regular expresion' do
        expect(words_array.my_none? { |x| x.match(/z/) }).to eql(true)
      end

      it 'returns true if the block never returns true for all elements' do
        expect(numbers_array.my_none?(String)).to eql(true)
      end
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

    it 'returns a new array with the results of running a proc once for every element in enum' do
      expect(number_range.my_map(&another_proc)).to eql([2, 3, 4, 5, 6])
    end
  end

  describe 'my_inject' do
    context 'A block is given' do
      it 'combines all elements of enum by applying a binary operation specified by a block' do
        expect(number_range.my_inject { |sum, x| sum + x }).to eq(15)
      end

      it 'combines all elements of an array by applying a binary operation
      specified by a block and an initial argument' do
        expect(numbers_array.my_inject(2) { |prod, x| prod * x }).to eq(240)
      end

      it 'combines all elements of an array by applying a binary operation specified by a proc' do
        expect(numbers_array.my_inject(&a_proc)).to eq(15)
      end
    end

    context 'No block given' do
      it 'combines all elements of enum by applying a binary operation specified by a symbol' do
        expect(number_range.my_inject(:*)).to eq(120)
      end
    end
  end
end
