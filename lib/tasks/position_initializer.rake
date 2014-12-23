desc 'Earlier delimiter used to be comma(,), but for #19, delimter is changed to \r\n'
namespace :rapidfire do
  task position_initializer: :environment do
    qgroups=Rapidfire::QuestionGroup.all
    qgroups.each do |group|
      questions=Rapidfire::Question.where(question_group_id: group.id).where("position is NULL").order("created_at")
      lastpos=Rapidfire::Question.where(question_group_id: group.id).where("NOT position is NULL").order("position").last.position
      max=0
      if lastpos
        max=lastpos
      end
      questions.each do |question|
          max=max+1
          question.position=max
          question.save
      end
    end
  end
end
