json.success true

json.attempt @attempt, partial: 'attempt', as: :attempt

json.answers do
    json.array! @answers, partial: 'rapidfire/api/answers/answer', as: :answer
end
