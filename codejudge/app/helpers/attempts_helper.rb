module AttemptsHelper
  def attempt_status(attempt)
    Score.where(attempt_id: attempt.id).pluck(:passed).all?()
  end

  def attempt_status_string(attempt)
    scores = Score.where(attempt_id: attempt.id).pluck(:passed)
    p scores
    if scores.length == 0 and attempt.passed.nil?
       "Running"
    elsif scores.all?() and attempt.passed != false
      p "attempt test true score"

      "Passed"
    elsif attempt.passed == true
      p "attempt test true"

      "Passed"
    else
      p "attempt test"
      "Failed"
    end 
  end
end
