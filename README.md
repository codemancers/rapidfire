# Rapidfire [![Code Climate](https://codeclimate.com/repos/51a70089f3ea000534070811/badges/aedc90c3b5481e7569bb/gpa.png)](https://codeclimate.com/repos/51a70089f3ea000534070811/feed)
One stop solution for all survey related requirements! Its tad easy!

## Installation
Add this line to your application's Gemfile:

    gem 'rapidfire', git: "git@github.com:code-mancers/rapidfire.git"

And then execute:

    $ bundle install
    $ bundle exec rake rapidfire:install:migrations
    $ bundle exec rake db:migrate

And if you want to customize rapidfire views, you can do

    $ bundle exec rails generate rapidfire:views

## Usage

Add this line to your routes will and you will be good to go!

    mount Rapidfire::Engine => "/rapidfire"

And point your browser to [http://localhost:3000/rapidfire](http://localhost:3000/rapidfire)

All rapidfire controllers inherit from your `ApplicationController`. So define 2
methods `current_user` and `can_administer?` on your `ApplicationController`

1. `current_user` : the user who is answering the survey. can be `nil`
2. `can_administer?` : a method which determines whether current user can
   create/update survey questions.

Typical implementation would be:

```ruby
  class ApplicationController < ActionController::Base
    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def can_administer?
      current_user.try(:admin?)
    end
  end
```

If you are using authentication gems like devise, you get `current_user` for free
and you don't have to define it.


## How it works
This gem gives you access to create questions in a groups, something similar to
survey. Once you have created a group and add questions to it, you can pass
around the form url where others can answer your questions.

The typical flow about how to use this gem is:

1. Create a question group by giving it a name.
2. Once group is created, you can click on the group which takes you to another
   page where you can manage questions.
3. Create a question by clicking on add new, and you will be provided by these
   options: Each question will have a type
   - **Checkbox** Create a question which contains multiple checkboxes with the
     options that you provide in `answer options` field. Note that each option
     should be on a separate line.
   - **Date** It takes date as an answer
   - **Long** It needs a description as answer. Renders a textarea.
   - **Numeric** It takes a number as an answer
   - **Radio** It renders set of radio buttons by taking answer options.
   - **Select** It renders a dropdown by taking answer options.
   - **Short** It takes a string as an answer. Short answer.

4. Once the type is filled, you can optionally fill other details like
   - **Question text** What is the question?
   - **Answer options** Give options separated by newline for questions of type
     checkbox, radio buttons or select.
   - **Answer presence** Should you mandate answering this question?
   - **min and max length** Checks whether answer if in between min and max length.
     Ignores if blank.
   - **greater than and less than** Applicable for numeric question where answer
     is validated with these values.

5. Once the questions are populated, you can return to root_path ie by clicking
   `Question Groups` and share distribute answer url so that others can answer
   the questions populated.
6. Note that answers fail to persist of the criteria that you have provided while
   creating questions fail.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
