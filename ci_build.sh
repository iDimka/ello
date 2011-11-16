#!/bin/sh

# Build the target.
xcodebuild -target ello -configuration Debug clean
xcodebuild -target ello -configuration Debug build
