import QtQuick
import QtQuick.Shapes

Rectangle {
    id: launch_7
    width: 283
    height: 49
    color: "#212741"
    radius: 9
    smooth: false
    antialiasing: false
    Image {
        id: launch_10
        x: 0
        y: 0
        width: 283
        height: 49
        source: Qt.resolvedUrl("assets/MoreInfoDropdown.svg")
        smooth: false
        fillMode: Image.PreserveAspectFit
        cache: false
    }

    Item {
        id: sync_4
        width: 0
        height: 0
        Rectangle {
            id: bounding_box_3
            width: 0
            height: 0
            color: "#d9d9d9"
        }

        Shape {
            id: _vector_2
            width: 0
            height: 0
            ShapePath {
                id: _vector_2_ShapePath0
                strokeWidth: 0.03
                strokeStyle: ShapePath.SolidLine
                strokeColor: "#00000000"
                PathSvg {
                    id: _vector_2_ShapePath0_PathSvg0
                    path: "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z"
                }
                joinStyle: ShapePath.MiterJoin
                fillRule: ShapePath.WindingFill
                fillColor: "#e3e3e3"
            }
        }
    }

    Item {
        id: textContainer_3
        x: 58
        y: 8
        width: 198
        height: 21
        Item {
            id: frame_4
            x: 6
            width: 186
            height: 21
        }
        clip: true
    }
    clip: true
}
