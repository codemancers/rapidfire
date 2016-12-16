json.surveys do
  json.array! @surveys, partial: 'surveys/survey.json', as: :survey
end
