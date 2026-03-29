import QtQuick
import QtQuick.Shapes

Rectangle {
    id: launch_6

    // Let parent screens opt into the shared hover polish without changing
    // the base title layout or adding extra logic to every instance.
    property bool hovered: false

    height: 37
    width: 314

    clip: true
    color: "#212741"
    radius: 9

    CardHoverEffect {
        anchors.fill: parent
        cornerRadius: parent.radius
        hovered: launch_6.hovered
    }

    Image {
        id: launch_7

        source: Qt.resolvedUrl("assets/TITLESettingsLONG.svg")
    }
    Item {
        id: sync_4

        height: 0
        width: 0

        Rectangle {
            id: bounding_box_3

            height: 0
            width: 0

            color: "#d9d9d9"
        }
        Shape {
            id: _vector_2

            height: 0
            width: 0

            ShapePath {
                id: _vector_2_ShapePath0

                fillColor: "#e3e3e3"
                fillRule: ShapePath.WindingFill
                joinStyle: ShapePath.MiterJoin
                strokeColor: "#00000000"
                strokeStyle: ShapePath.SolidLine
                strokeWidth: 0.03

                PathSvg {
                    id: _vector_2_ShapePath0_PathSvg0

                    path: "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z"
                }
            }
        }
    }
    Item {
        id: textContainer_3

        x: 58
        y: 8

        height: 21
        width: 198

        clip: true

        Item {
            id: frame_4

            x: 6

            height: 21
            width: 186

            Text {
                id: title_3

                height: 21
                width: 187

                color: "#ffffff"
                font.capitalization: Font.AllUppercase
                font.family: "Interstate"
                font.pixelSize: 15
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "Simulation Controls"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
