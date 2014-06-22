import sys

try:
    import wx
except ImportError:
    print 'wx is not installed. Please install wx 3.0.0.0 osx-cocoa (classic).'
    sys.exit(1)

app = wx.PySimpleApp()
colors = ['Red', 'Blue', 'Green', 'Pink', 'White']
dialog = wx.SingleChoiceDialog(
    None, 'Pick something...', 'Pick a Color', colors)
dialog.ShowModal()
