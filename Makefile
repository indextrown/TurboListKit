.PHONY: docs clean-docs

docs:
	xcodebuild docbuild \
	-workspace TurboListKit.xcworkspace \
	-scheme TurboListKit \
	-destination 'generic/platform=iOS' \
	-derivedDataPath .build

	xcrun docc process-archive transform-for-static-hosting \
	.build/Build/Products/Debug-iphoneos/TurboListKit.doccarchive \
	--output-path ./docs \
	--hosting-base-path TurboListKit

clean-docs:
	rm -rf docs
	rm -rf .build
