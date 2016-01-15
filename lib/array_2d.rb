class Array2D
  include Enumerable
  attr_accessor :state

  def initialize(rows, columns, value=nil)
    @state = Array.new(rows) { Array.new(columns) { value } }
  end

  def each(&block)
    @state.each do |row|
      row.each do |e|
        yield e
      end
    end
  end

  def each_with_index(&block)
    @state.each_with_index do |row, row_index|
      row.each_with_index do |e, column_index|
        yield e, [row_index, column_index]
      end
    end   
  end

  def to_s
    @state.to_s
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def size
    [row_size, column_size]
  end

  def row_size
    @state.size
  end

  def column_size
    @state[0].size
  end

  def [](x, y)
    case x
    when Integer
      case y
      when Integer
        @state[x][y]
      when Range
        if y.size <= column_size
          subarray = Array.new(y.to_a.size)
          y.each {|yi| subarray[yi - y.first] = @state[x][yi]}
          subarray
        else
          raise IndexError, "Indices are out of range"
        end
      end
    when Range
      case y
      when Integer
        if x.size <= row_size
          subarray = Array.new(x.to_a.size)
          x.each {|xi| subarray[xi - x.first] = @state[xi][y]}
          subarray
        else
          raise IndexError, "Indices are out of range"
        end
      when Range
        if x.size <= row_size && y.size <= column_size
          subarray = Array2D.new(x.to_a.size, y.to_a.size)
          x.each do |xi|
            y.each do |yi|
              subarray.state[xi - x.first][yi - y.first] = @state[xi][yi]
            end
          end
          subarray
        else
          raise IndexError, "Indices are out of range"
        end
      end
    end
  end

  def []=(x, y, value)
    case x
    when Integer
      case y
      when Integer
        @state[x][y] = value
      when Range
        if value.is_a?(Array) && y.to_a.size == value.size
          y.each {|yi| @state[x][yi] = value[yi - y.first]}
        else
          y.each {|yi| @state[x][yi] = value}
        end    
      end
    when Range
      case y
      when Integer
        if value.is_a?(Array) && x.to_a.size == value.size
          x.each {|xi| @state[xi][y] = value[xi - x.first]}
        else
          x.each {|xi| @state[xi][y] = value}
        end
      when Range
        x.each do |xi|
          y.each do |yi|
            if value.is_a?(Array2D) && [x.to_a.size, y.to_a.size] == value.size
              @state[xi][yi] = value[xi - x.first, yi - y.first]
            else
              @state[xi][yi] = value
            end
          end
        end
      end
    end
  end

end

class IndexError < StandardError; end