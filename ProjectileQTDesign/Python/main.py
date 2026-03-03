import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
from controller import GameController

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get path to this Python file
    current_dir = os.path.dirname(os.path.abspath(__file__))

    # Go up one level to find Screen_1.ui.qml
    qml_path = os.path.abspath(
        os.path.join(current_dir, "..", "Main.qml")
    )
    controller = GameController()
    engine.rootContext().setContextProperty("game", controller)

    print("Loading:", qml_path)

    engine.load(QUrl.fromLocalFile(qml_path))

    if not engine.rootObjects():
        print("QML failed to load")
        sys.exit(-1)

    return app.exec()


if __name__ == "__main__":
    sys.exit(main())