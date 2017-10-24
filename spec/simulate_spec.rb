
require 'pry'
require 'rspec'
require_relative '../simulate.rb'

describe Simulate do
  
  before do
    ENV['RACK_ENV'] = 'test'
  end
  
  after(:each)do
    FileUtils.rm_f Dir.glob("spec/outputs/*")
  end

  context "Sad Path" do
    
    it "raises missing command per line" do
      no_command = "inputs/invalid/no_command.txt"
      simulator = Simulate.new(input_file_path: no_command)
      simulator.start
      
      expect(simulator.errors).to include("No command to execute")
    end
    
    it "raises to many commands per line" do
      to_many_commands = "inputs/invalid/to_many_commands.txt"
      simulator = Simulate.new(input_file_path: to_many_commands) 
      simulator.start
      
      expect(simulator.errors).to include("There can be only one command per line")
    end
    
    it "raises wrong file format error" do
      wrong_format = "inputs/invalid/wrong_format.docx"
      
      expect { 
        Simulate.new(input_file_path: wrong_format)  
      }.to raise_error(ArgumentError, "Can't read .docx files, please give a '.txt' file")
    end
    
    it "raises no valid definations" do
      no_definations = "inputs/invalid/no_definations.txt"
      simulator = Simulate.new(input_file_path: no_definations) 
      simulator.start
      
      expect(simulator.errors).to include("There are no definations to work with")
    end
  end

  context "Happy Path" do
    
    it "successfully simulates first example" do
      example_one = "inputs/valid/example_one.txt"
      simulator = Simulate.new(input_file_path: example_one) 
      simulator.start
      
      expect(simulator.candidates.count).to eq(1)
      
      lines = [
        "DEFINE ManualReview BackgroundCheck DocumentSigning \n",
        "ManualReview 0 BackgroundCheck 0 DocumentSigning 0 Hired 0 Rejected 0 \n",
        "CREATE howon@fountain.com \n",
        "ADVANCE howon@fountain.com \n",
        "Rejected howon@fountain.com \n",
        "ManualReview 0 BackgroundCheck 0 DocumentSigning 0 Hired 0 Rejected 1 \n"
      ]
      
      line_no = 0
      
      File.open("spec/outputs/example_one_output.txt", "r").each_line do |line|
        expect(line).to eq(lines[line_no])
        line_no += 1
      end
    end
    
    it "successfully simulates second example" do
      example_two = "inputs/valid/example_two.txt"
      simulator = Simulate.new(input_file_path: example_two) 
      simulator.start
      
      expect(simulator.candidates.count).to eq(2)
      
      lines = [
        "DEFINE ManualReview BackgroundCheck \n",
        "CREATE dan@fountain.com \n",
        "CREATE paul@fountain.com \n",
        "Duplicate applicant \n",
        "ADVANCE paul@fountain.com \n",
        "Already in BackgroundCheck \n",
        "Hired paul@fountain.com \n",
        "Failed to decide for dan@fountain.com \n",
        "ADVANCE dan@fountain.com \n",
        "Hired dan@fountain.com \n"
      ]
      
      line_no = 0
      
      File.open("spec/outputs/example_two_output.txt", "r").each_line do |line|
        expect(line).to eq(lines[line_no])
        line_no += 1
      end
    end
    
    it "successfully simulates three example" do
      example_three = "inputs/valid/example_three.txt"
      simulator = Simulate.new(input_file_path: example_three) 
      simulator.start
      
      expect(simulator.candidates.count).to eq(5)
      
      lines = [
        "DEFINE ManualReview BackgroundCheck DocumentSigning \n", 
        "ManualReview 0 BackgroundCheck 0 DocumentSigning 0 Hired 0 Rejected 0 \n", 
        "CREATE user_one@example.com \n", 
        "CREATE dan@fountain.com \n", 
        "CREATE paul@fountain.com \n", 
        "Duplicate applicant \n", 
        "CREATE bligzna.lauris@gmail.com \n", 
        "CREATE user_two@example.com \n", 
        "ADVANCE user_one@example.com \n", 
        "ADVANCE paul@fountain.com \n", 
        "ADVANCE dan@fountain.com \n", 
        "Already in BackgroundCheck \n", 
        "ADVANCE bligzna.lauris@gmail.com \n", 
        "Hired bligzna.lauris@gmail.com \n", 
        "Rejected user_two@example.com \n", 
        "Failed to decide for dan@fountain.com \n", 
        "ManualReview 0 BackgroundCheck 2 DocumentSigning 1 Hired 1 Rejected 1 \n" 
      ]
      
      line_no = 0
      
      File.open("spec/outputs/example_three_output.txt", "r").each_line do |line|
        expect(line).to eq(lines[line_no])
        line_no += 1
      end
    end
    
  end

end