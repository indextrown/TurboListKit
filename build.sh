swift package clean

swift build
swift test

xcodebuild build \
-scheme TurboListKit \
-destination 'generic/platform=iOS'