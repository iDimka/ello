#!/bin/sh

# Build the target.
xcodebuild -target mytarget -configuration Debug clean
xcodebuild -target mytarget -configuration Debug build
