class Questions::Numeric < Question
  def validate_answer(answer)
    super(answer)

    if rules[:presence]
      validation_rules = rules.slice(:greater_than_or_equal_to, :less_than_or_equal_to)
      answer.validates_numericality_of :answer_text, validation_rules
    end
  end
end
