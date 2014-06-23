# Hello App Store

This is a barebones Python app that can be submitted to the Mac App Store.

It displays a simple dialog and exits.

## Choosing a GUI Library

Any app you submit to the Mac App Store must have a GUI. In Python there are a few libraries available to create a GUI:

* **[Tkinter] / Tk** - Built-in to Python. Just works.
    * Poorly documented. Limited widget set.
    * Overhead: Nothing
* **[PyObjC] / Cocoa**
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
    * Cannot be submitted to Mac App Store due to wxPython's reliance on [deprecated QuickTime APIs](https://groups.google.com/forum/#!topic/wxpython-mac/BeUS9GHigvE).
    * Overhead: 38.7 MB uncompressed, 13.3 MB compressed
* **[PySide] / QT**
    * Well documented. Unsure if maintained.
    * The app created by py2app crashes with a segmentation fault. My guess is that the py2app needs a special "recipe" for PySide. I don't feel like writing one myself.
    * Overhead: 16.6 MB uncompressed, 6.3 MB compressed (estimated)
* **[PyQt]4 / QT**
    * Unable to build from source and no binary installers for OS X are available. Seriously don't people test anything these days?

The above assessment leaves the following choices for Mac App Store apps:

* Tkinter
* PyObjC
* ctypes

Probably PyObjC is the best choice to get full functionality. I'm disappointed that wxPython gets the shaft here, as most of my preexisting GUI apps in Python are written with wxPython.

This example app uses PyObjC by default but includes samples for several of the other GUI libraries.

[ctypes]: https://docs.python.org/2/library/ctypes.html
[Tkinter]: https://wiki.python.org/moin/TkInter
[wxPython]: http://wxpython.org
[PySide]: http://www.pyside.org/
[PyQt]: http://www.riverbankcomputing.com/software/pyqt/intro
[PyObjC]: https://pythonhosted.org/pyobjc/