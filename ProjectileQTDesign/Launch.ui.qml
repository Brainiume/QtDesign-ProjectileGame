import QtQuick

Rectangle {
    id: launch

    height: 37
    width: 175

    border.color: "#78ded5d5"
    border.width: 1
    clip: true
    color: "#212741"
    radius: 9

    Image {
        id: ellipse_1

        source: Qt.resolvedUrl("assets/ellipse_1.png")
    }
}