from PySide.QtGui import QApplication
from PySide.QtGui import QMessageBox
import sys

def main():
    app = QApplication(sys.argv)
    QMessageBox.information(None, 'Greetings', 'Hello World!')
    app.exec_()
