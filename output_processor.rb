require './input_scanner.rb'

class OutputProcessor
  @@output = []

  def self.output
    @@output
  end

  def self.append_error
    @@output << InputScanner::ERROR
  end

  def initialize(assignments, metal_values)
    @assignments = assignments
    @metal_values = metal_values
  end

  def process_output_howmuch(processed_line)
    value = decimal_calculation(processed_line[1])
    @@output << (processed_line[1] <<'is '<<"#{value}")
  end

  def process_output_howmany(processed_line)
    mul_factor = decimal_calculation(processed_line[2])
    value = mul_factor * @metal_values[processed_line[3]]
    @@output << (processed_line[2] <<processed_line[3] << ' is ' << "#{value.to_i} " << processed_line[1])
  end

  def decimal_calculation(arr)
    v1 = arr.split(' ')
    value = 0
    i = 0
    while i < v1.size
      if (i+1 < v1.size) && (@assignments[v1[i]] < @assignments[v1[i+1]])
        value =  value + ((@assignments[v1[i+1]] - @assignments[v1[i]]))
        i = i + 2
      else
        value = value + @assignments[v1[i]]
        i = i + 1
      end
    end
    return value
  end

end