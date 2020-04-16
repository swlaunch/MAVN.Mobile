# Open MAVN

## Run tests with coverage:
1. (Optional - if you don't have lcov installed) brew install lcov
2. flutter test --coverage && genhtml coverage/lcov.info -o coverage && open coverage/index.html
Note: Only the files touched by the tests will be reported, not all .dart files.
---

## Pre-build

"flutter run" has a few issues with flavors and doesn't work as it should most of the times. Examples:
1. on Android if you run one flavor and then another, it would not switch the environment in Flutter properly
2. on iOS, "flutter run" installs all flavors, but starts for debugging only 1 of those flavors, the others just get stuck, unless you run it a second time.

####To fix these issues, there is a small script that you can run before "flutter run": "pre-build-scripts/pre_build_qa.sh" or "pre-build-scripts/pre_build_dev.sh" depending on which flavor you intend to run. (NOTE: You can add this script in the Intellij Run/Debug Configurations in the Before launch section)

---

## Pre-commit

As a good practice, before you push, you should: 
1. run the formatter on dart files
2. check there are no flutter analyzer issues.
3. make sure *ALL* tests are passing(unless you use TDD, and commit failing tests on purpose). 
4. update the localisation scripts

You can install our pre-commit script and pre push scripts in order to automatically do the things above when you run a `git commit` and `git push` command respectively. To get it working you need to:
1. run `git config core.hooksPath .githooks/`
2. Next time you run `git commit` the script will run and it will *STOP* the commit if files have changed from the format or tests failed.  
  
The pre-commit script runs the formatter and the localisation scripts (when prompted on the command line).
The pre-push script runs the analyzer and the tests.
  
 **Note!: If you want to not run the script when you commit(if you do TDD or you just don't want to), then run: `git commit --no-verify`**  
 **To restore to the default, run: `git config core.hooksPath .git/hooks/`**
---

## Flutter Driver integration tests

### How to run:
Note: Only run on an iOS or Android emulator. Physical devices are not supported yet.
1. make sure only ***one*** iOS/Android emulator is running
2. (on MAC) run from terminal in the project root: 
    - if iOS: `./pre-build-scripts/pre_build_automation.sh && flutter drive -t test_driver/app_ios.dart --flavor automation`  
    - if Android: `./pre-build-scripts/pre_build_automation.sh && flutter drive -t test_driver/app_android.dart --flavor automation`     
NOTE: Run the 

### How they work:
The Flutter Driver tests use the Gherkin framework, and are supported by the **flutter_gherkin**(https://pub.dev/packages/flutter_gherkin) Flutter plugin.  

The tests are driven by the `.feature` files in each feature directory. These `.feature` files follow the Gherkin syntax and every **Scenario** will run as a separate test. For each individual Gherkin **Step** the framework will match it to a handler class(e.g. *WhenIAmOnPage* class) which will contain the test logic but also the step matching logic.

Please check the **flutter_gherkin**(https://pub.dev/packages/flutter_gherkin) plugin documentation for more information.

---

### Debugging Analytics

###

When running the iOS App, to see live analytics data in the Analytics > DebugView section of Firebase, add the following CommandLineArgument element to [environment].xcscheme.
See https://medium.com/flutterpub/using-firebase-analytics-in-flutter-2da5be205e4

```
<LaunchAction

 ...
 <!-- Copy and paste the following: Do not commit this -->
  <CommandLineArguments>
     <CommandLineArgument
        argument = "-FIRDebugEnabled"
        isEnabled = "YES">
     </CommandLineArgument>
  </CommandLineArguments>
  
 ...
 
</LaunchAction>
```
Do not commit this.

---

## Golden tests
https://medium.com/flutter-community/flutter-golden-tests-compare-widgets-with-snapshots-27f83f266cea

At the start of each test suite, call initScreenshots from *test/helpers/golden_test_helper.dart*. This is to set up the document size of the screenshot, hide the debug banner and manually load the fonts for testing.
```
setUpAll(() {
  initScreenshots();
});
```

Then when you want to take/compare a screenshot of a widget call 'thenWidgetShouldMatchScreenshot', passing the
widgetTester, the finder that will resolve to the wanted widget and a unique name for the screenshot file
```
await thenWidgetShouldMatchScreenshot(widgetTester, find.byType(OfferDetailsPage), 'offer_details_page');
```

To generate/regenerate all screenshots:
```
flutter test --update-goldens test
```

To generate new screenshots for one test:
```
flutter test --update-goldens <relative_path_to_test_file> (e.g. flutter test --update-goldens test/feature_account_deactivated/view/account_deactivated_page_test.dart)
```

To test screenshots: (To check if the widget matches the screenshot)
```
flutter test test
```

---