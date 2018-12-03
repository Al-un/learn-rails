Travis:
[![Build Status](https://travis-ci.com/Al-un/learnzone-rails.svg?branch=master)](https://travis-ci.com/Al-un/learnzone-rails)
CircleCI:
[![CircleCI](https://circleci.com/gh/Al-un/learnzone-rails.svg?style=svg)](https://circleci.com/gh/Al-un/learnzone-rails)

Code Climate:
[![Maintainability](https://api.codeclimate.com/v1/badges/7bb038bdf3cf874ef3e9/maintainability)](https://codeclimate.com/github/Al-un/learnzone-rails/maintainability)[![Test Coverage](https://api.codeclimate.com/v1/badges/7bb038bdf3cf874ef3e9/test_coverage)](https://codeclimate.com/github/Al-un/learnzone-rails/test_coverage)
Codacy:
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/09fa7d649b2c4b488755f37c12644207)](https://www.codacy.com/app/alun/learnzone-rails?utm_source=github.com&utm_medium=referral&utm_content=Al-un/learnzone-rails&utm_campaign=Badge_Grade)
Codebeat:
[![codebeat badge](https://codebeat.co/badges/ad1591f7-9321-475e-af03-482b6c296e5f)](https://codebeat.co/projects/github-com-al-un-learnzone-rails-master)

# Learning Zone

Rails Fullstack implementation of the LearnZone project. Parent repository is
https://github.com/Al-un/learn-zone

## Fullstack version using Rails

Just Rails

## Temporary code

Temporary code are implemented but not meant to be persistent and must be
removed when appropriate.

- [x][tmp-001] products with no user are updated with the currently logged user
  Removed 761cc262a56b996bf3d71ad2cbf3b1af37ecb9a0.
- [ ][tmp-002] bad scope testing

## Tutorial

- Testing
  - [BetterSpecs pratices](http://www.betterspecs.org/)
  - Faker
    - [Github](https://github.com/stympy/faker)
  - FactoryBot
    - [FactoryBot getting started](https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md)
    - [Test your factories first](https://robots.thoughtbot.com/testing-your-factories-first)
    - [Testing factories](<https://github.com/thoughtbot/factory_bot/wiki/Testing-all-Factories-(with-RSpec)>)
    - [Factory Traits](https://robots.thoughtbot.com/remove-duplication-with-factorygirls-traits)
  - SimpleCov
    - [Github](https://github.com/colszowka/simplecov)
    - [Documentation](https://www.rubydoc.info/gems/simplecov/frames)
    - [Rails config](https://andycroll.com/ruby/use-simplecov/)
  - Capybara
    - [Github](https://github.com/teamcapybara/capybara)
    - [Capybara, Selenium and headless Chrome](https://www.lucascaton.com.br/2017/06/22/how-to-run-your-feature-specs-using-capybara-and-headless-chrome/)
    - [Long Live PhantomJS, let's use chromium](http://www.akitaonrails.com/2017/10/31/beginner-long-live-phantomjs-let-s-use-chrome-headless-now)
  - Authorization
    - [OmniAuth testing doc](https://github.com/omniauth/omniauth/wiki/Integration-Testing)
    - [Test your social signin](https://pdabrowski.com/blog/ruby-on-rails/testing/integration-tests-with-omniauth/)
  - Coverage
    - [CodeClimate+CircleCI doc](https://docs.codeclimate.com/docs/circle-ci-test-coverage-example)
  - https://www.netguru.co/codestories/end-to-end-tests-on-circleci-with-docker-rails-capybara-selenium
- Deployment
  - [CircleCI deploy to Heroku](https://circleci.com/docs/2.0/deployment-integrations/#heroku)
  - [CircleCI tagged commit](https://circleci.com/docs/2.0/workflows/#git-tag-job-execution)
