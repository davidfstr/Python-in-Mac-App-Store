from Tkinter import Tk
import tkMessageBox

def main():
    # Force Tk's required top-level window to be hidden
    top = Tk()
    top.state('withdrawn')

    # Display simple dialog
    tkMessageBox.showinfo('Greetings', 'Hello World!')
