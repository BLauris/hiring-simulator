require_relative 'commands.rb'
require_relative 'lib/candidate.rb'
require 'fileutils'

class Simulate < Commands

  attr_reader :errors, :output_file, :candidates, 
              :input_file, :execute_line, :stages

  def self.run!(input_file_path)
    simulate = self.new(input_file_path: input_file_path)
    simulate.start
  end
  
  def initialize(input_file_path: )
    @input_file = init_input(input_file_path)
    @output_file = init_output
    @stages = []
    @candidates = []
    @errors = []
  end
  
  def start
    begin
      read_file
    rescue RuntimeError => error
      errors << error.message
      clear_output
      print_errors
    end
  end
    
  private
  
    def read_file
      input_file.each_line do |line|
        @execute_line = line        
        write_to_file(execute_command)
      end
      
      input_file.close
    end
    
    def init_input(path)
      File.open(path, "r") if valid_file?(path)
    end
    
    def init_output
      extn = File.extname(input_file)
      file = "outputs/" + File.basename(input_file, extn) + "_output.txt"      
      file = "spec/" + file if ENV['RACK_ENV'] == 'test'
      file
    end
    
    def clear_output
      ::FileUtils.rm_f Dir.glob("outputs/#{File.basename(output_file)}")
    end
    
    def print_errors
      puts "--------- ERRORS --------"
      errors.each{ |error| puts error }
      puts "-------------------------"
    end
end