@Rapidfire ||= {}

class Rapidfire.QuestionForm
  constructor: (@$form)->
    @bindQuestionType()
    @onTypeChange()

  bindQuestionType: ->
    @$form.on "change", "#question_type", @onTypeChange

  onTypeChange: (e)=>
    console.info @$form.find("#question_type option:selected").text()
    switch @$form.find("#question_type option:selected").text()
      when "Select", "Checkbox", "Radio"
        @$form.find("#question_answer_options_wrapper").show()
        @$form.find("#question_answer_minimum_length_wrapper").hide()
        @$form.find("#question_answer_maximum_length_wrapper").hide()
        @$form.find("#question_answer_greater_than_or_equal_to_wrapper").hide()
        @$form.find("#question_answer_less_than_or_equal_to_wrapper").hide()
      when "Short", "Long"
        @$form.find("#question_answer_options_wrapper").hide()
        @$form.find("#question_answer_minimum_length_wrapper").show()
        @$form.find("#question_answer_maximum_length_wrapper").show()
        @$form.find("#question_answer_greater_than_or_equal_to_wrapper").hide()
        @$form.find("#question_answer_less_than_or_equal_to_wrapper").hide()
      when "Date"
        @$form.find("#question_answer_options_wrapper").hide()
        @$form.find("#question_answer_minimum_length_wrapper").hide()
        @$form.find("#question_answer_maximum_length_wrapper").hide()
        @$form.find("#question_answer_greater_than_or_equal_to_wrapper").hide()
        @$form.find("#question_answer_less_than_or_equal_to_wrapper").hide()
      when "Numeric"
        @$form.find("#question_answer_options_wrapper").hide()
        @$form.find("#question_answer_minimum_length_wrapper").hide()
        @$form.find("#question_answer_maximum_length_wrapper").hide()
        @$form.find("#question_answer_greater_than_or_equal_to_wrapper").show()
        @$form.find("#question_answer_less_than_or_equal_to_wrapper").show()
