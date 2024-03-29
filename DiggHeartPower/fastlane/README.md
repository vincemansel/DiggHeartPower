fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios create_app
```
fastlane ios create_app
```
Create app on Apple Developer and App Store Connect sites
### ios screenshot
```
fastlane ios screenshot
```
Take screenshots
### ios build
```
fastlane ios build
```
Create ipa
### ios beta
```
fastlane ios beta
```

### ios upload
```
fastlane ios upload
```
Upload to App Store
### ios do_everything
```
fastlane ios do_everything
```
Create app, take screenshots, build and upload to App Store

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
