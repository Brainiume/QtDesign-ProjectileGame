import QtQuick

Rectangle {
    id: root

    property bool hovered: false
    property real cornerRadius: 10
    property color glowColor: "#8dded5d5"

    radius: cornerRadius
    color: hovered ? "#12ffffff" : "transparent"
    border.color: hovered ? glowColor : "#00000000"
    border.width: hovered ? 1 : 0
    opacity: hovered ? 1.0 : 0.0
    z: 2

    // Keep the hover feedback subtle and premium rather than flashy.
    Behavior on opacity {
        NumberAnimation {
            duration: 120
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 120
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }
}
