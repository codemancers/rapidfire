# Change Log

- Add `position` attribute to `Question` model.  
  Fixes #79  
  
  Leon Hooijer

## [v3.0.0](https://github.com/code-mancers/rapidfire/tree/HEAD)

[Changelog](https://github.com/code-mancers/rapidfire/compare/v2.1.0...HEAD)

**Implemented enhancements:**
- Add rake task and generator to rename tables for users to upgrade from previous version to 3.0.0.

- Rename `Answer_groups` to `attempts`  
  Rename rails migrations from `Answer_groups` to `attempts`.  
  Rename routes in views

- Rename `Question_groups` to `surveys`  
  Rename rails migrations from `question_groups` to `surveys`.
  Rename `question_groups_controller` to `surveys_controller`.  
  Rename routes in views

- Use rails strong_parameters to support Rails 4 and Rails 5.
