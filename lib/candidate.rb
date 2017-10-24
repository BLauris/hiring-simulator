require_relative 'support.rb'

class Candidate
  include Support
  
  attr_reader :line, :email, :stage, :approved
  
  def initialize(line:, stage:)
    @line = line
    @email = find_email(line)
    @stage = stage
    @approved = nil
  end
  
  def approve_or_reject!(approval)
    @approved = approval == "1"
  end
  
  def update_stage!(new_stage)
    @stage = new_stage
  end
  
end