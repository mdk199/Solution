require './roman_to_decimal.rb'
require './output_processor.rb'

class InputScanner
    ERROR = 'I have no idea what you are talking about'
    REGEX_ASSIGNMENT = "^([a-z]+) is ([I|V|X|L|C|D|M])$"
    REGEX_CREDITS = "((?:[a-z]+ )+)([A-Z]\\w+) is (\\d+) ([A-Z]\\w+)$"
    REGEX_HOWMANY= "^how many ([a-zA-Z]\\w+) is ((?:\\w+ )+)([A-Z]\\w+) \\?$"
    REGEX_HOWMUCH = "^how much is ((?:\\w+[^0-9] )+)\\?$"
    QUERY_TYPE = {
                  0 => 'assignment',
                  1 => 'credit',
                  2 => 'how_many',
                  3 => 'how_much'
                }
    @@roman_literal_values = RomanToDecimal.roman_literal_values

  def initialize(filename)
    @filename = filename
  end

  def process_input
    fileObj = File.new(@filename, "r")
    assignment = {}
    metal_values = {}
    while (line = fileObj.gets)
      line = line.chomp
      flag = check_queries(line)
      case QUERY_TYPE[flag]
        when 'assignment'
          assign_values(line, assignment)
        when 'credit'
          process_metal_values(line, metal_values, assignment)
        when 'how_much'
          op = OutputProcessor.new(assignment, metal_values)
          op.process_output_howmuch(regex_matcher(line, REGEX_HOWMUCH))
        when 'how_many'
          op = OutputProcessor.new(assignment, metal_values)
          op.process_output_howmany(regex_matcher(line, REGEX_HOWMANY))
        else
          OutputProcessor.append_error
      end
    end
    fileObj.close
  end

  def regex_matcher(line, regex)
    return line.match(regex)
  end

  private

    def check_queries(line)
      if regex_matcher(line, REGEX_ASSIGNMENT)
        return 0
      elsif regex_matcher(line, REGEX_CREDITS)
        return 1
      elsif regex_matcher(line, REGEX_HOWMANY)
        return 2
      elsif regex_matcher(line, REGEX_HOWMUCH)
        return 3
      end
    end

    def assign_values(line, assignment)
      arr = regex_matcher(line, REGEX_ASSIGNMENT)
      assignment[arr[1]] = @@roman_literal_values[arr[2]]
    end

    def process_metal_values(line, metal_values, assignments)
      arr = regex_matcher(line, REGEX_CREDITS)
      rfactor = OutputProcessor.new(assignments, metal_values).decimal_calculation(arr[1])
      metal_values[arr[2]] = arr[3].to_f/rfactor
    end
end