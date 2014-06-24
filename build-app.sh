#!/bin/sh
# 
# Creates ./dist/HelloAppStore.app
# 

APP_PATH=dist/HelloAppStore.app

# The package signing identity corresponds to a "3rd Party Mac Developer Application"
# certificate that resides within the Keychain Access application.
SIGNING_IDENTITY="3rd Party Mac Developer Application: David Foster"

# Ensure building with Python 2.7
# NOTE: If a different version of Python is desired, the Python patching steps
#       that occur later in this script must be updated.
python -V 2> build/python_version.txt
PYTHON_VERSION=`cat build/python_version.txt`
if [[ $PYTHON_VERSION != Python\ 2.7* ]]; then
    echo "*** This packaging script requires Python 2.7."
    exit 1
fi

# Ensure wx is present and is the expected version
python -c 'import wx' 2> /dev/null
if [[ $? != 0 ]]; then
    echo "*** This application requires wx to be installed."
    exit 1
fi
WX_VERSION=`python -c 'import wx; print wx.version()'`
if [[ $WX_VERSION != "3.0.0.0 osx-cocoa (classic)" ]]; then
    echo "*** This application is only tested with wx 3.0.0.0 osx-cocoa (classic)"
    echo "    Other versions of wx might not work."
    # (continue)
fi

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

# Sign the app, frameworks, and all helper tools as required by the Mac App Store.
# (This example app has no helper tools.)
# 
# NOTE: Inner frameworks and tools must be signed before the outer app package.
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