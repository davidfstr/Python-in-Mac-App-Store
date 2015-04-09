#!/bin/sh
# 
# Creates ./dist/HelloAppStore.app
# 

APP_PATH=dist/HelloAppStore.app

mkdir -p dist build

# Ensure building with Python 2.7
# NOTE: If a different version of Python is desired, the Python patching steps
#       that occur later in this script must be updated.
python -V 2> build/python_version.txt
PYTHON_VERSION=`cat build/python_version.txt`
if [[ $PYTHON_VERSION != Python\ 2.7* ]]; then
    echo "*** This packaging script requires Python 2.7."
    exit 1
fi

# Build dist/HelloAppStore.app
python setup.py py2app

# Limit Universal Binaries to only contain the architechures {i386, x86_64},
# since these are the only architechures permitted on the Mac App Store.  
# 
# In addition, remove all i386 items since all Macs models from early 2007 and 
# newer have x86_64 support (aka Core 2 Duo or newer).  This will save 1.1MB
# of space in Python's libraries alone, more from other frameworks..
remove_arch () {
    lipo -output build/lipo.tmp -remove "$1" "$2" && mv build/lipo.tmp "$2"
}
for i in ${APP_PATH}/Contents/Resources/lib/python2.7/lib-dynload/* ; do
    #remove_arch ppc ${i}
    remove_arch i386 ${i}
done

# Import configuration related to code signing
source code-signing-config.sh

# Sign the app, frameworks, and all helper tools as required by the Mac App Store.
# (This example app has no helper tools.)
# 
# NOTE: Inner frameworks and tools must be signed before the outer app package.
# NOTE: codesign with the -f option can incorrectly return exit status of 1
if [ ${DO_CODE_SIGNING} -eq 1 ] ; then
    codesign -s "$SIGNING_IDENTITY_APP" -f \
        "$APP_PATH/Contents/Frameworks/Python.framework/Versions/2.7"
    codesign -s "$SIGNING_IDENTITY_APP" -f \
        --entitlements src/app.entitlements \
        "$APP_PATH/Contents/MacOS/HelloAppStore"
    codesign -s "$SIGNING_IDENTITY_APP" -f \
        --entitlements src/app.entitlements \
        "$APP_PATH/Contents/MacOS/python"
fi

exit 0
