import QtQuick.Templates as T
import QtQuick
import QtQml

T.Button {
    enum Status_1 {
        Status_1_Default,
        Status_1_Disabled,
        Status_1_Hovered,
        Status_1_Pressed
    }

    id: buttonRoot

    property int status: ControlsButton.Status_1.Status_1_Default

    height: 41
    width: 194

    background: Rectangle {
        id: controlsButton

        color: "#46a1bb"
        radius: 10
    }
    contentItem: Item {
        id: buttonRootCI

        Image {
            id: launch

            source: Qt.resolvedUrl("assets/launch_3.png")
        }
        Text {
            id: label

            x: 72.50
            y: 12

            height: 17
            width: 50

            color: "#fcfcfc"
            font.family: "Inter"
            font.pixelSize: 14
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            text: "Simulate"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }
    }

    states: [
        State {
            name: "Status=Default"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Default
        },
        State {
            name: "Status=Hovered"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Hovered

            PropertyChanges {
                color: "#1f9b5d"
                target: controlsButton
            }
            PropertyChanges {
                source: Qt.resolvedUrl("assets/launch_2.png")
                target: launch
            }
            PropertyChanges {
                x: 68

                target: label
            }
            PropertyChanges {
                text: "Simulate"
            }
            PropertyChanges {
                width: 59

                target: label
            }
        },
        State {
            name: "Status=Pressed"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Pressed

            PropertyChanges {
                color: "#12834b"
                target: controlsButton
            }
            PropertyChanges {
                source: Qt.resolvedUrl("assets/launch_1.png")
                target: launch
            }
            PropertyChanges {
                x: 69

                target: label
            }
            PropertyChanges {
                target: label
                text: "Simulate"
            }
            PropertyChanges {
                width: 57

                target: label
            }
        },
        State {
            name: "Status=Disabled"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Disabled

            PropertyChanges {
                color: "#12834b"
                target: controlsButton
            }
            PropertyChanges {
                x: 67

                target: label
            }
            PropertyChanges {
                target: label
                text: "Simulating"
            }
            PropertyChanges {
                target: label
            }
            PropertyChanges {
                width: 61

                target: label
            }
            PropertyChanges {
                target: launch
                visible: false
            }

            PropertyChanges {
                target: buttonRoot
            }
        }
    ]

    Binding {
        property: "status"
        target: buttonRoot
        value: !buttonRoot.enabled ? ControlsButton.Status_1.Status_1_Disabled : buttonRoot.down ? ControlsButton.Status_1.Status_1_Pressed : buttonRoot.hovered ? ControlsButton.Status_1.Status_1_Hovered : ControlsButton.Status_1.Status_1_Default
    }
}
