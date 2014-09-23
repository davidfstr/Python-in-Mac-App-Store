# Hello App Store

This is a barebones Python app that can be submitted to the Mac App Store.

It displays a simple dialog and exits.

## Quickstart

### Prerequisites

* OS X 10.8 (Mountain Lion)
    * Other OS X versions from 10.6+ will probably work.
* Python 2.7.x
    * This exact version of Python is required because the build process has patching steps specific to `lib/python2.7`.
* py2app 0.8.1 or later
    * Really old versions of py2app create invalid `Python.framework` bundles in generated apps that won't pass Mac App Store checks.
* **(Optional)** wx 3.0.0.0 osx-cocoa (classic)
* **(Optional)** PySide 1.1.1 / QT 4.8.6
* **(Optional)** PtQt 4.11 / sip 4.16.1 / QT 4.8.6

### How to Build

1. Clone this repository or download a ZIP file of it:
    * `git clone https://github.com/davidfstr/Python-in-Mac-App-Store.git`
    * `cd Python-in-Mac-App-Store`
2. Configure code signing:
    * **(Option 1)** If you have Mac App Store signing certificates, update the `SIGNING_IDENTITY` line in `./build-app.sh` and `./build-pkg.sh` to refer to them:
        * You will need an [Apple Developer account](https://developer.apple.com/devcenter/mac/) and a subscription to the Mac Developer Program ($99/year) to get signing certificates.
        * Create the appropriate Mac App Store certificates in the [Mac Dev Center](https://developer.apple.com/account/mac/certificate/) and download them to your dev machine.
    * **(Option 2)** If you do not have a Mac App Store signing certificate:
        1. Comment out all `codesign` commands in `./build-app.sh`.
        2. Remove the `--sign "$SIGNING_IDENTITY"` option from `./build-pkg.sh`
        3. With these modifications you will be able to build the app and the installer package, but you will not be able to submit them to the store.
4. Build the app package `dist/HelloAppStore.app`:
    * `./build-app.sh`
5. Build the installer package `dist/HelloAppStore.pkg`:
    * `./build-pkg.sh`

### How to Submit

1. Create a record for your app inside [iTunes Connect](https://itunesconnect.apple.com/).
    * Create a unique *bundle identifier* for your app record and update the `CFBundleIdentifier` key in `src/Icon.plist` to match it.
    * Fill out app metadata, including its description, keywords, screenshots, etc.
    * Press "Ready to Upload Binary".
2. Open Application Loader:
    * Open Xcode.
    * From the menubar, select Xcode > Open Developer Tool > Application Loader.
3. Click "Deliver Your App" and select the app record you created in iTunes Connect.
3. When you are prompted for an item to upload, select `dist/HelloAppStore.pkg`.

## Writing your Own App?


### Choosing a GUI Library

Any app you submit to the Mac App Store must have a GUI. In Python there are a few libraries available to create a GUI:

* **[Tkinter] / Tk** - Built-in to Python. Just works.
    * Poorly documented. Limited widget set.
    * Overhead: Nothing
* **[PyObjC] / Cocoa** - Full bindings to the Cocoa frameworks.
    * Reasonably documented and maintained. (But requires you to learn Cocoa.)
    * Provides full access to all OS X native widgets.
    * Overhead: Nothing
* **[ctypes] / Cocoa** - Low-level bindings directly to Cocoa frameworks.
    * Most direct way to access native Cocoa frameworks, albeit verbose.
    * Almost no online documentation for this approach.
        * The [cocoa-python](https://code.google.com/p/cocoa-python/) library exposes a tiny subset of Cocoa using ctypes. Reading its source code is illustrative.
    * Overhead: Nothing
* **[wxPython] / wxWidgets**
    * Well documented. Lots of widgets.
    * **Note:** Cannot be submitted to Mac App Store due to wxPython's reliance on [deprecated QuickTime APIs](https://groups.google.com/forum/#!topic/wxpython-mac/BeUS9GHigvE).
    * Overhead: 38.7 MB uncompressed, 13.3 MB compressed
* **[PySide] / QT**
    * Well documented. Unsure if maintained.
    * **Note:** The app created by py2app crashes with a segmentation fault. My guess is that the py2app needs a special "recipe" for PySide. I don't feel like writing one myself.
    * Overhead: 16.6 MB uncompressed, 6.3 MB compressed (estimated)
* **[PyQt]4 / QT**
    * **Note:** I am unable to build from source and no binary installers for OS X are available. Seriously don't people test anything these days?

The above assessment leaves the following choices for Mac App Store apps:

* Tkinter
* PyObjC
* ctypes

Probably PyObjC is the best choice to get full functionality. I'm disappointed that wxPython gets the shaft here, as most of my preexisting GUI apps in Python are written with wxPython.

This example app uses Tkinter by default but includes samples for several of the other GUI libraries.

If you'd like to try the other samples, open `src/HelloAppStore.py` and change the `main` function to call one of the other libraries.

[ctypes]: https://docs.python.org/2/library/ctypes.html
[Tkinter]: https://wiki.python.org/moin/TkInter
[wxPython]: http://wxpython.org
[PySide]: http://www.pyside.org/
[PyQt]: http://www.riverbankcomputing.com/software/pyqt/intro
[PyObjC]: https://pythonhosted.org/pyobjc/
