# Random fail
~/rails/BrainDriller
$ rta                                                                          [main]
Run options: --seed 18030

# Running:

```md
...Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62753
Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62756
.Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62761
Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62765
Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62771
.Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62781
...Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62787
Capybara starting Puma...
* Version 5.3.2 , codename: Sweetnighter
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:62794
....................[Screenshot Image]: /Users/uni/rails/BrainDriller/tmp/screenshots/failures_test_solve_drill_by_logout_user.png
.F

Failure:
DrillsTest#test_solve_drill_by_logout_user [/Users/uni/rails/BrainDriller/test/system/drills_test.rb:84]:
expected to find text "Correct" in "BrainDriller"


rails test test/system/drills_test.rb:76
```

Correctの文字は画像で見えている。

## CircleCIで落ちる。

```
..............S...[Screenshot Image]: /home/circleci/circleci-demo-ruby-rails/tmp/screenshots/failures_test_solve_drill_by_logout_user.png
F

Failure:
DrillsTest#test_solve_drill_by_logout_user [/home/circleci/circleci-demo-ruby-rails/test/system/drills_test.rb:84]:
expected to find text "Correct" in "BrainDriller". (However, it was found 1 time including non-visible text.)


rails test test/system/drills_test.rb:76

.[Screenshot Image]: /home/circleci/circleci-demo-ruby-rails/tmp/screenshots/failures_test_solve_drill.png
.F

Failure:
DrillsTest#test_solve_drill [/home/circleci/circleci-demo-ruby-rails/test/system/drills_test.rb:43]:
expected to find text "Correct" in "BrainDriller". (However, it was found 1 time including non-visible text.)
```
