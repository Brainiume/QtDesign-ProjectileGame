import QtQuick

Item {
    id: root
    width: 100
    height: 40

    property int barCount: 6
    property color barColor: "#4a5190"
    property real progress: 0.0   // master animation value

    // Single master animation
    NumberAnimation on progress {
        from: 0
        to: 1
        duration: 1100
        loops: Animation.Infinite
        easing.type: Easing.Linear
        running: true
    }

    Row {
        opacity: 0.7
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: root.barCount

            Rectangle {
                width: 6
                radius: 3
                color: root.barColor

                // Wave math (never desyncs)
                property real wave:
                    Math.sin((root.progress * 6.28) + (index * 0.7))

                height: 20 + (wave * 10)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
