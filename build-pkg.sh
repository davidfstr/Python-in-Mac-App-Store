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

source code-signing-config.sh

dash_dash_sign=''
if [ ${DO_CODE_SIGNING} -eq 1 ] ; then
    dash_dash_sign="--sign ${SIGNING_IDENTITY}"
fi

# NOTE: If having trouble with signing, debug by removing the --sign flag and
#       trying to sign manually with the productsign command
productbuild --component dist/HelloAppStore.app /Applications dist/HelloAppStore.pkg \
    $dash_dash_sign

# vim:ts=4:sts=4:sw=4:et
