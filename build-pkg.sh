#!/bin/sh
# 
# Creates ./dist/HelloAppStore.pkg, which can be submitted to the Mac App Store
# using XCode's Application Loader tool
# 

# The package signing identity corresponds to a "Developer ID Installer"
# certificate that resides within the Keychain Access application.
SIGNING_IDENTITY="3rd Party Mac Developer Installer: David Foster"

# Check prerequisites
if [ ! -d dist/HelloAppStore.app ]; then
    echo "*** Must build app before building pkg."
    exit 1
fi

# NOTE: If having trouble with signing, debug by removing the --sign flag and
#       trying to sign manually with the productsign command
productbuild --component dist/HelloAppStore.app /Applications dist/HelloAppStore.pkg \
    --sign "$SIGNING_IDENTITY"
