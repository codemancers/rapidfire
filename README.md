# Rapidfire

One stop solution for all survey related requirements! Its tad easy!

This gem supports:

- **rails**: 4.2, 5.0, 5.1, 5.2, 6.0, 6.1 and 7.0
- **ruby**: 2.4, 2.5, 2.6, 2.7, 3.0, 3.1 and 3.2

NOTE: Some combinations won't be supported. Please check CI for the ignored ones.

A simple implementaiton of this gem can be found at [https://rapidfire.fly.dev](https://rapidfire.fly.dev).
And the source code of application is [https://github.com/code-mancers/rapidfire-app](https://github.com/code-mancers/rapidfire-app).

## Installation

Add this line to application's Gemfile:

```rb
gem 'rapidfire'
```

And then execute:

```shell
$ bundle install
$ bundle exec rake rapidfire:install:migrations
$ bundle exec rake db:migrate
```

Rapidfire views can also be customized. This command copies the views into `app/views` directory:

```sh
$ bundle exec rails generate rapidfire:views
```

Rapidfire locales (i18n) files can also be customized. The command is:

```sh
$ bundle exec rails generate rapidfire:locales
```

## Usage

Add this line to `config/routes.rb` file, thats good enough

```rb
mount Rapidfire::Engine => "/rapidfire"
```

Please point the browser to [http://localhost:3000/rapidfire](http://localhost:3000/rapidfire)

All rapidfire controllers inherit from your `ApplicationController`. So define 2
methods `current_user` and `can_administer?` on your `ApplicationController`

1. `current_user` : the user who is answering the survey. can be `nil`
2. `can_administer?` : a method which determines whether current user can
   create/update survey questions.
3. `owner_surveys_scope` : the scope of surveys for this entity, for multi-tenancy. Defaults to `Survey`

Typical implementation would be:

```rb
class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def can_administer?
    current_user.try(:admin?)
  end

  def owner_surveys_scope
    current_user.surveys
  end
end
```

It also will assume that whatever `current_user` returns above will respond to a method called `survey_name`.

That method should return the name that is associated with the results. For example:

```rb
class User
  def survey_name
    "#{last_name}, #{first_name}"
  end
end
```

If the application is using authentication gems like Devise, Devise will automatically provide `current_user`
helper for free. There is no need to define it

### Override

Override path to redirect after answer the survey

```ruby
# my_app/app/decorators/controllers/rapidfire/attempts_controller_decorator.rb
Rapidfire::AttemptsController.class_eval do
  def after_answer_path_for
    main_app.root_path
  end
end
```

### Routes Information

Once this gem is mounted on, say at 'rapidfire', it generates several routes
They can be listed by running `bundle exec rake routes`.

1. The `root_path` i.e `localhost:3000/rapidfire` always points to list of
   surveys {they are called question groups}. Admin can manage surveys, and
   any user {who cannot administer} can see list of surveys.
2. Optionally, each survey can by answered by visiting this path:

   ```
   localhost:3000/rapidfire/surveys/<survey-id>/attempts/new
   ```

   This url can be distributed so that survey takers can attempt the survey

3. If you have an established application that uses route helpers and/or the
   `url_for([@model1, @model2])` style, you can include your route helpers in
   RapidFire by adding `config/initializers/rapidfire.rb` with the
   following content:

   ```ruby
   Rails.application.config.after_initialize do
     Rails.application.reload_routes!

     Rapidfire::ApplicationController.class_eval do
       main_app_methods = Rails.application.routes.url_helpers.methods
       main_app_route_methods = main_app_methods.select{|m| m =~ /_url$/ || m =~ /_path$/ }
       main_app_route_methods.each do |m|
         define_method m do |*args|
           main_app.public_send(m, *args)
         end
         helper_method m
       end
     end
   end
   ```

### Survey Results

There is an API for fetching the results. This is not efficient, but is provided for the sake
of quickly aggregating survey results

```
GET /rapidfire/surveys/<survey-id>/results
```

This new api supports two formats: `html` and `json`. The `json` format can be used with any
javascript based chart solutions like Chart.js. An example can be seen
[here](https://github.com/code-mancers/rapidfire-app).

Diving into details of `json` format, all the questions can be categorized into
one of the two categories:

1. **aggregatable**: questions like checkboxes, selects, radio buttons fall into
   this category.
2. **non-aggregatable**: questions like long answers, short answers, date, numeric
   etc.

All the aggregatable answers will be returned in the form of hash, and the
non-aggregatable answers will be returned in the form of an array. A typical json
output will be like this:

```json
[
  {
    "question_type": "Rapidfire::Questions::Radio",
    "question_text": "Who is author of Waiting for godot?",
    "results": {
      "Sublime": 1,
      "Emacs": 1,
      "Vim": 1
    }
  },
  {
    "question_type": "Rapidfire::Questions::Checkbox",
    "question_text": "Best rock band?",
    "results": {
      "Led Zeppelin": 2
    }
  },
  {
    "question_type": "Rapidfire::Questions::Date",
    "question_text": "When is your birthday?",
    "results": ["04-02-1983", "01/01/1970"]
  },
  {
    "question_type": "Rapidfire::Questions::Long",
    "question_text": "If Apple made a android phone what it will be called?",
    "results": ["Idude", "apdroid"]
  },
  {
    "question_type": "Rapidfire::Questions::Numeric",
    "question_text": "Answer of life, universe and everything?",
    "results": ["42", "0"]
  },
  {
    "question_type": "Rapidfire::Questions::Select",
    "question_text": "Places you want to visit after death",
    "results": {
      "Iran": 2
    }
  }
]
```

## How it works

This gem gives on the fly access to create questions under a survey. Once the survey is
created, questions can be added to the survey. Every survey will have a url which can
be can passed around to others to take the survey.

The typical flow about how to use this gem is:

1. Create a survey by giving it a name.
2. Once the survey is created, start adding questions to the survey
3. Create a question by clicking on add new, and there will be several options
   Each question will have a type

   - **Checkbox** Create a question which contains multiple checkboxes with the
     options that you provide in `answer options` field. Note that each option
     should be on a separate line.
   - **Date** It takes date as an answer
   - **Long** It needs a description as answer. Renders a textarea.
   - **Numeric** It takes a number as an answer
   - **Radio** It renders set of radio buttons by taking answer options.
   - **Select** It renders a dropdown by taking answer options.
   - **Short** It takes a string as an answer. Short answer.
   - **File** It renders a file input which can take only 1 file.
   - **MultiFile** It renders a file input which can take multile files.

4. Once the type is filled, optionally other details can be filled:

   - **Question text** What is the question?
   - **Answer options** Give options separated by newline for questions of type
     checkbox, radio buttons or select.
   - **Answer presence** Should you mandate answering this question?
   - **min and max length** Checks whether answer if in between min and max length.
     Ignores if blank.
   - **greater than and less than** Applicable for numeric question where answer
     is validated with these values.

5. Once the questions are populated, a url will be created which can be shared
6. Note that answers fail to persist if the criteria provided while creating the
   questions fail.

## Notes on upgrading

##### Adding multitenancy support

```shell
$ rake rapidfire:upgrade:migrations:multitenancy
```

##### Upgrading from 2.1.0 to 3.0.0

Some table names have changed:

- `rapidfire_question_groups` to `rapidfire_surveys`, and
- `rapidfire_answer_groups` to `rapidfire_attempts`.

Run this rake task to do this change automatically

```shell
$ rake rapidfire:upgrade:migrations:from210to300
```

##### Upgrading from 1.2.0 to 2.0.0

The default delimiter which is used to store options for questions like select
input, multiple answers for checkbox question is comma (,). This resulted in
problems where gem is unable to parse options properly if answers also contain
commas. For more information see [issue-19](https://github.com/code-mancers/rapidfire/issues/19).

Starting from version `2.0.0` default delimiter is changed to `\r\n`, but a
configuration is provided to change the delimiter. Please run this rake task
to make existing questions or stored answers to use new delimiter.

NOTE: Please take database backup before running this rake task.

```rb
bundle exec rake rapidfire:change_delimiter_from_comma_to_srsn
bundle exec rake rapidfire:change_delimiter_from_comma_to_srsn
```

If this change is not feasible rightaway, and the application needs to use comma
as delimiter, then please use this initializer, but be warned that in future
delimiter will be hardcoded to `\r\n`:

```rb
# /<path-to-app>/config/initializers/rapidfire.rb

Rapidfire.config do |config|
  config.answers_delimiter = ','
end
```

## TODO

1. Add ability to sort questions, so that order is preserved.

## Contributing

1. Fork it
2. Create a feature branch (`git checkout -b my-new-feature`)
3. Commit all the changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
