module Validator
  
  VALID_STAGE_NAMES = ["ManualReview", "PhoneInterview", "BackgroundCheck", "DocumentSigning"]
  VALID_COMMANDS = ["DEFINE", "CREATE", "ADVANCE", "DECIDE", "STATS"]
  
  def more_than_one_command?
    count = 0
    VALID_COMMANDS.each{ |command| count += 1 if execute_line.include?(command) }
    raise RuntimeError.new("There can be only one command per line") if count > 1
  end
  
  def valid_file?(input_file)
    extn = File.extname(input_file)
    
    unless extn == ".txt"
      raise ArgumentError.new("Can't read #{extn} files, please give a '.txt' file")
    end
    
    true
  end
  
  def has_any_valid_defination?
    if stages.count < 1
      raise RuntimeError.new("There are no definations to work with")
    end
    
    true
  end
  
  def duplicate_candidate?
    !candidate.nil? && candidate.email == find_email(execute_line)
  end
  
  def candidate_in_last_stage?(candidate)
    candidate.stage == stages.last
  end
  
  def adnavnce_to_certain_stage?
    VALID_STAGE_NAMES.detect{ |s| execute_line.include?(s) }
  end
  
  def approved?
    candidate_approval == "1"
  end
  
  def rejected?
    candidate_approval == "0"
  end
  
end