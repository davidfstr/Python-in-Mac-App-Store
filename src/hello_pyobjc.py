import AppKit

def main():
    alert = AppKit.NSAlert.alertWithMessageText_defaultButton_alternateButton_otherButton_informativeTextWithFormat_(
        "Hello World", "OK", None, None, "")
    alert.runModal()
