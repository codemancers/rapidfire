class Questions::Select < Question
  validates :answer_options, :presence => true

  def options
    answer_options.split(/\r?\n/)
  end

  def validate_answer(answer)
    super(answer)

    if rules[:presence]
      answer.validates_inclusion_of :answer_text, :in => options
    end
  end
end
