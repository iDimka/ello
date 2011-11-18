#!/bin/sh

# Build the target.
xcodebuild -target ello -configuration Release clean
xcodebuild -target ello -configuration Release build
