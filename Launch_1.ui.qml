import QtQuick
import QtQuick.Shapes

Rectangle {
    id: launch

    height: 144
    width: 314

    border.color: "#78ded5d5"
    border.width: 1
    clip: true
    color: "#b2212741"
    radius: 9

    Rectangle {
        id: mask

        height: 144
        width: 314

        color: "transparent"
        radius: 9
    }
    Image {
        id: intersect

        source: Qt.resolvedUrl("assets/intersect_6.png")
    }
    Text {
        id: title

        x: 37
        y: 9

        height: 21
        width: 246

        color: "#ffffff"
        font.capitalization: Font.AllUppercase
        font.family: "Interstate"
        font.pixelSize: 15
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignHCenter
        text: "Congrats, You hit the target!"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: title_1

        x: 37
        y: 38

        height: 93
        width: 246

        color: "#ffffff"
        font.family: "Interstate"
        font.pixelSize: 14
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignHCenter
        text: "Have a go at the next level!
 Watchout for the new wind speed!  "
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
    Item {
        id: frame

        x: 8
        y: 6

        height: 24
        width: 24

        clip: true

        Shape {
            id: _vector

            x: 2
            y: 3

            height: 19
            width: 20

            ShapePath {
                id: _vector_ShapePath0

                fillColor: "#00000000"
                fillRule: ShapePath.WindingFill
                strokeColor: "#ffffff"
                strokeWidth: 2.20

                PathSvg {
                    id: _vector_ShapePath0_PathSvg0

                    path: "M 14 10.37440013885498 C 17.531800031661987 11.068800151348114 20 12.65470004081726 20 14.5 C 20 16.985300064086914 15.522799968719482 19 10 19 C 4.477149963378906 19 0 16.985300064086914 0 14.5 C 0 12.65470004081726 2.4681899547576904 11.068800151348114 6 10.37440013885498 M 10 14 L 10 0 L 15.317699432373047 3.272439956665039 C 15.705599427223206 3.5111399590969086 15.899499077349901 3.630489930510521 15.96139907836914 3.7808499336242676 C 16.01539907976985 3.9119999408721924 16.01109940186143 4.059899806976318 15.949699401855469 4.187709808349609 C 15.879199400544167 4.334259808063507 15.678700417280197 4.4422201961278915 15.277700424194336 4.6581501960754395 L 10 7.5"
                }
            }
        }
    }
}