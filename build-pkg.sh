#!/bin/sh
# 
# Creates ./dist/HelloAppStore.pkg, which can be submitted to the Mac App Store
# using XCode's Application Loader tool
# 

# Check prerequisites
if [ ! -d dist/HelloAppStore.app ]; then
    echo "*** Must build app before building pkg."
    exit 1
fi

# Import configuration related to code signing
source code-signing-config.sh

if [ ${DO_CODE_SIGNING} -eq 1 ] ; then
    # NOTE: If having trouble with signing, debug by removing the --sign flag and
    #       trying to sign manually with the productsign command
    productbuild --component dist/HelloAppStore.app /Applications dist/HelloAppStore.pkg \
        --sign "${SIGNING_IDENTITY_INSTALLER}"
else
    productbuild --component dist/HelloAppStore.app /Applications dist/HelloAppStore.pkg
fi

