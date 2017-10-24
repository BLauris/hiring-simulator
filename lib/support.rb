module Support
  
  def find_email(line)
    emails = []
    line.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) { |email| emails << email } 
    
    if emails.count == 1
      emails.first
    else
      raise "There can be only one valid email"
    end   
  end
  
  def candidate
    candidates.select{|candidate| candidate.email == find_email(execute_line) }.first
  end
  
  def count_candidates_in_stage(stage)
    candidates.select{|candidate| candidate.stage == stage && candidate.approved.nil? }.count
  end
  
  def approved_count
    candidates.select{|candidate| candidate.approved == true }.count
  end
  
  def rejected_count
    candidates.select{|candidate| candidate.approved == false }.count
  end
  
end