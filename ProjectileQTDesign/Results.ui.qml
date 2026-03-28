import QtQuick
import QtQuick.Shapes
import QtQuick.VectorImage 6.8

Item {
    id: frame_2

    height: 262
    width: 400
    // Allow the existing results UI to be reused with live data from Screen_1.
    property string flightTimeText: "0.0s"
    property string maxHeightText: "0.0m"
    property string attemptsText: "0"
    property string totalDisplacementText: "0.0m"

    Rectangle {
        id: launch

        x: 36
        y: 16

        height: 37
        width: 328

        border.color: "#78ded5d5"
        border.width: 1
        clip: true
        color: "#212741"
        radius: 9

        Rectangle {
            id: mask

            height: 37
            width: 175

            color: "transparent"
            radius: 9
        }
        Image {
            id: intersect

            source: Qt.resolvedUrl("assets/Results/resultgradient")
        }
        Item {
            id: rotate_1

            x: 11
            y: 7

            height: 24
            width: 24

            clip: true

            Item {
                id: frame

                height: 24
                width: 24

                clip: true

                VectorImage {
                    id: _vector

                    x: 2.50
                    y: 2

                    height: 19.50
                    source: "assets/Results/rocket.svg"
                    preferredRendererType: VectorImage.CurveRenderer
                    antialiasing: true
                    smooth: true
                    fillMode: VectorImage.PreserveAspectFit
                    width: 19.50
                }
            }
        }
        Item {
            id: textContainer

            x: 35
            y: 9

            height: 21
            width: 190

            clip: true

            Item {
                id: frame_1

                x: 5.50

                height: 21
                width: 179

                Text {
                    id: title

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    text: "Simulation Results"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Rectangle {
        id: launch_1

        x: 36
        y: 60

        height: 186
        width: 328

        border.color: "#78ded5d5"
        border.width: 1
        clip: true
        color: "#e5212741"
        radius: 9

        Rectangle {
            id: launch_2

            x: 7
            y: 7

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_1

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_1

                source: Qt.resolvedUrl("assets/Results/resultgradient_1.png")
            }
            Item {
                id: frame_3

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_4

                    x: 2.08
                    y: 2.08

                    height: 21.88
                    width: 21.88

                    clip: true

                    VectorImage {
                        id: _vector1

                        x: 2.50
                        y: 2

                        height: 19.50
                        source: "assets/Results/time.svg"
                        preferredRendererType: VectorImage.CurveRenderer
                        antialiasing: true
                        smooth: true
                        fillMode: VectorImage.PreserveAspectFit
                        width: 19.50
                    }
                }
            }
            Item {
                id: textContainer_1

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_1

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "Flight time"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: flightTime

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllLowercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: frame_2.flightTimeText
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: launch_3

            x: 7
            y: 51

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_2

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_2

                source: Qt.resolvedUrl("assets/Results/resultgradient_2.png")
            }
            Item {
                id: frame_5

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_6

                    x: 1
                    y: 1

                    height: 24
                    width: 24

                    clip: true

                    VectorImage {
                        id: _vector2

                        x: 2.50
                        y: 2

                        height: 19.50
                        source: "assets/Results/height.svg"
                        preferredRendererType: VectorImage.CurveRenderer
                        antialiasing: true
                        smooth: true
                        fillMode: VectorImage.PreserveAspectFit
                        width: 19.50
                    }
                }
            }
            Item {
                id: textContainer_2

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_3

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "MAx Height"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: maxHeight

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllLowercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: frame_2.maxHeightText
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: launch_4

            x: 7
            y: 95

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_3

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_3

                source: Qt.resolvedUrl("assets/Results/resultgradient_3.png")
            }
            Item {
                id: frame_7

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_8

                    x: 1
                    y: 1

                    height: 24
                    width: 24

                    clip: true

                    VectorImage {
                        id: _vector3

                        x: 2.50
                        y: 2

                        height: 19.50
                        source: "assets/Results/attempts.svg"
                        preferredRendererType: VectorImage.CurveRenderer
                        antialiasing: true
                        smooth: true
                        fillMode: VectorImage.PreserveAspectFit
                        width: 19.50
                    }
                }
            }
            Item {
                id: textContainer_3

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_5

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "Attempts"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: attempts

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: frame_2.attemptsText
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: launch_5

            x: 7
            y: 139

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_4

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_4

                source: Qt.resolvedUrl("assets/Results/resultgradient_4.png")
            }
            Item {
                id: frame_9

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_10

                    x: 1
                    y: 1

                    height: 24
                    width: 24

                    clip: true

                    VectorImage {
                        id: _vector4

                        x: 2.50
                        y: 2

                        height: 19.50
                        source: "assets/Results/time.svg"
                        preferredRendererType: VectorImage.CurveRenderer
                        antialiasing: true
                        smooth: true
                        fillMode: VectorImage.PreserveAspectFit
                        width: 19.50
                    }
                }
            }
            Item {
                id: textContainer_4

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_7

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "Total displacement"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: totalDisplacement

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllLowercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: frame_2.totalDisplacementText
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
