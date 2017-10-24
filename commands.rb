require_relative 'lib/support.rb'
require_relative 'lib/validator.rb'

class Commands
  include Support
  include Validator
  
  def execute_command
    if find_comand
      send(find_comand.downcase)
    else
      raise "No command to execute"
    end 
  end
  
  def define
    VALID_STAGE_NAMES.each{ |stage| stages << stage if execute_line.include?(stage) }    
    "DEFINE #{stages.join(" ")}" if has_any_valid_defination?
  end
  
  def create
    if duplicate_candidate?
      "Duplicate applicant"
    else
      candidate = Candidate.new(line: execute_line, stage: stages.first)
      candidates << candidate 
      "CREATE #{candidate.email}"
    end
  end
  
  def advance
    case 
    when !find_stage_to_advance.nil? && find_stage_to_advance == candidate.stage
      "Already in #{find_stage_to_advance}"
    when !find_stage_to_advance.nil? && !candidate_in_last_stage?(candidate)
      candidate.update_stage!(find_stage_to_advance)
      "ADVANCE #{candidate.email}"
    when !candidate_in_last_stage?(candidate)
      candidate.update_stage!(next_stage(candidate)) 
      "ADVANCE #{candidate.email}"
    else
      raise "Something went wrong!"
    end
  end
  
  def decide
    case 
    when rejected?
      candidate.approve_or_reject!(candidate_approval)
      "Rejected #{candidate.email}"
    when approved? && candidate_in_last_stage?(candidate)
      candidate.approve_or_reject!(candidate_approval)
      "Hired #{candidate.email}" 
    else
      "Failed to decide for #{candidate.email}"
    end
  end
  
  def stats
    count_candidate_per_stage
  end
  
  private
  
    def find_comand
      unless more_than_one_command? 
        VALID_COMMANDS.detect { |command| execute_line.include?(command) }
      end
    end
  
    def count_candidate_per_stage
      line = ""
      
      if candidates.any?
        stages.each{ |stage| line = line + "#{stage} #{count_candidates_in_stage(stage)} " }
        line = line + "Hired #{approved_count} "
        line + "Rejected #{rejected_count}"
      else
        stages.each{ |stage| line = line + "#{stage} 0 " }
        line + "Hired 0 Rejected 0"
      end
    end
    
    def write_to_file(text)
      File.open(output_file, 'a+') do |file| 
        file.write(text + " \n") 
        file.close
      end
    end
    
    def find_stage_to_advance
      VALID_STAGE_NAMES.detect{ |stage| execute_line.include?(stage) }
    end
    
    def next_stage(candidate)
      index = stages.index(candidate.stage) + 1
      stages[index]
    end
    
    def candidate_approval
      execute_line.split(/\s+/).last
    end
end