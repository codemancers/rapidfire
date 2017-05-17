json.surveys do
  json.array! @surveys, partial: 'survey', as: :survey
end
