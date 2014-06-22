#!/bin/sh
# 
# Creates ./dist/HelloAppStore.app
# 

APP_PATH=dist/HelloAppStore.app

# The package signing identity corresponds to a "Developer ID Application"
# certificate that resides within the Keychain Access application.
SIGNING_IDENTITY="3rd Party Mac Developer Application: David Foster"

# Build dist/HelloAppStore.app
python setup.py py2app

# Limit Universal Binaries to only contain the architechures {i386, x86_64},
# since these are the only architechures permitted on the Mac App Store
remove_arch () {
    lipo -output build/lipo.tmp -remove "$1" "$2" && mv build/lipo.tmp "$2"
}
remove_arch ppc7400 \
    "$APP_PATH/Contents/Resources/lib/python2.7/lib-dynload/_sha256.so"
remove_arch ppc7400 \
    "$APP_PATH/Contents/Resources/lib/python2.7/lib-dynload/_sha512.so"

# Repair Python.framework to conform to "Anatomy of Framework Bundles",
# as required by the Mac App Store
ln -s \
    Versions/Current/Python \
    "$APP_PATH/Contents/Frameworks/Python.framework/Python"
ln -s \
    Versions/Current/Resources \
    "$APP_PATH/Contents/Frameworks/Python.framework/Resources"
ln -s \
    A \
    "$APP_PATH/Contents/Frameworks/Python.framework/Versions/Current"
ln -s \
    2.7 \
    "$APP_PATH/Contents/Frameworks/Python.framework/Versions/A"

# Sign the app, frameworks, and all helper tools, as required by the Mac App Store
# NOTE: Inner tools must be signed before the outer app package.
# NOTE: codesign with the -f option can incorrectly return exit status of 1
codesign -s "$SIGNING_IDENTITY" -f \
    "$APP_PATH/Contents/Frameworks/Python.framework/Versions/2.7"
codesign -s "$SIGNING_IDENTITY" -f \
    --entitlements src/app.entitlements \
    "$APP_PATH/Contents/MacOS/HelloAppStore"
codesign -s "$SIGNING_IDENTITY" -f \
    --entitlements src/app.entitlements \
    "$APP_PATH/Contents/MacOS/python"

exit 0