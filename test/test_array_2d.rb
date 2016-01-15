require 'helper'

class Array2DTest < Minitest::Test
  def setup
    @array2d = Array2D.new(3, 5, 0)
  end

  def test_initialize
    assert_instance_of Array2D, Array2D.new(3, 5)
    assert_instance_of Array2D, Array2D.new(3, 5, 0)
  end

  def test_initial_value
    assert_equal 0, @array2d[2, 2]
  end

  def test_each
    array2d = Array2D.new(2, 2)
    array2d.state = [[1, 2], [3, 4]]
    each_array = []
    array2d.each { |e| each_array << e }
    assert_equal [1, 2, 3, 4], each_array
  end

  def test_each_with_index
    array2d = Array2D.new(2, 2)
    array2d.state = [[1, 2], [3, 4]]
    each_array = []
    index_array = []
    array2d.each_with_index do |e, index|
      each_array << e 
      index_array << index
    end
    assert_equal [1, 2, 3, 4], each_array
    assert_equal [[0, 0], [0, 1], [1, 0], [1, 1]], index_array
  end

  def test_to_s
    array2d = Array2D.new(2, 2)
    array2d.state = [[1, 2], [3, 4]]
    assert_equal '[[1, 2], [3, 4]]', array2d.to_s
  end

  def test_equality
    @array2d[0..1, 0..1] = [[0, 1], [2, 3]]
    new_array2d = Array2D.new(3, 5, 0)
    new_array2d[0..1, 0..1] = [[0, 1], [2, 3]]
    assert @array2d == new_array2d
  end

  def test_size
    assert_equal [3, 5], @array2d.size
  end

  def test_row_size
    assert_equal 3, @array2d.row_size
  end

  def test_column_size
    assert_equal 5, @array2d.column_size
  end

  def test_bracket_with_integers
    @array2d[1, 2] = 4
    assert_equal 4, @array2d[1, 2]
  end

  def test_bracket_with_ranges
    array2d = Array2D.new(3, 3)
    subarray = Array2D.new(2, 2)
    subarray.state = [[0, 1], [2, 3]]
    array2d[0...2, 1...3] = subarray
    assert_equal subarray, array2d[0...2, 1...3]

    array2d[0...2, 1...3] = 5
    subarray = Array2D.new(2, 2, 5)
    assert_equal subarray, array2d[0...2, 1...3]
  end

  def test_bracket_with_integers_and_ranges
    @array2d[0..1, 0] = [0, 1]
    assert_equal [0, 1], @array2d[0..1, 0]

    @array2d[0, 0..1] = [2, 3]  
    assert_equal [2, 3], @array2d[0, 0..1]

    @array2d[0...3, 0] = 5
    assert_equal [5, 5, 5], @array2d[0...3, 0]

    @array2d[0, 0...5] = 7
    assert_equal [7, 7, 7, 7, 7], @array2d[0, 0...5]
  end

  def test_get_bracket_errors
    assert_raises(IndexError) do
      @array2d[0..(@array2d.row_size + 1), 0]
    end

    assert_raises(IndexError) do
      @array2d[0, 0..(@array2d.column_size + 1)]
    end

    assert_raises(IndexError) do
      @array2d[0..(@array2d.row_size + 1), 0..(@array2d.column_size + 1)]
    end
  end
end